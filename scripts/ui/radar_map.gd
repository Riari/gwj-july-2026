extends Control

const BG_COLOR := Color(0.06, 0.14, 0.06, 0.92)
const TILE_COLOR := Color(0.18, 0.6, 0.18, 0.65)
const PLAYER_COLOR := Color(0.3, 1.0, 0.3, 1.0)
const TARGET_COLOR := Color(0.3, 0.9, 0.3, 1.0)
const ENEMY_COLOR := Color(0.95, 0.18, 0.18, 1.0)
const BORDER_COLOR := Color(0.2, 0.55, 0.2, 0.9)
const WORLD_PADDING := 48.0

var _level: Node
var _player: Node2D
var _targets: Array[Node2D] = []
var _enemies: Array[Node2D] = []
var _tile_image: Image
var _tile_texture: ImageTexture
var _tile_bounds := Rect2()
var _tile_image_dirty := true
var _refresh_timer := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	_refresh_timer -= delta
	if _refresh_timer <= 0.0:
		_refresh_timer = 0.15
		_refresh()
	queue_redraw()

func _refresh() -> void:
	if _level == null:
		_level = _find_level()
		if _level == null:
			return
		_tile_image_dirty = true

	_collect_entities()
	_rebuild_tile_image_if_needed()

func _find_level() -> Node:
	var n := get_parent()
	while n:
		if n is Level:
			return n
		n = n.get_parent()
	return null

func _collect_entities() -> void:
	_targets.clear()
	_enemies.clear()
	_player = null
	if _level == null:
		return
	for c in _level.get_children():
		_collect_recursive(c)

func _collect_recursive(node: Node) -> void:
	if node is Character:
		if node.is_player():
			_player = node
		elif !node.is_dead():
			_enemies.append(node)
	elif node is Pickup:
		_targets.append(node)
	elif node.get_script() == preload("res://scripts/level_exit.gd"):
		_targets.append(node)
	for child in node.get_children():
		_collect_recursive(child)

func _rebuild_tile_image_if_needed() -> void:
	if !_tile_image_dirty:
		return
	_tile_image_dirty = false
	_tile_image = null
	_tile_texture = null
	_tile_bounds = Rect2()
	if _level == null:
		return
	var first := true
	for child in _level.get_children():
		if !(child is TileMapLayer):
			continue
		var tm := child as TileMapLayer
		for cell in tm.get_used_cells():
			var wp: Vector2 = tm.to_global(tm.map_to_local(cell))
			if first:
				_tile_bounds = Rect2(wp, Vector2.ONE)
				first = false
			else:
				_tile_bounds = _tile_bounds.expand(wp)
	if first:
		return
	var map_w := int(ceil(_tile_bounds.size.x)) + 1
	var map_h := int(ceil(_tile_bounds.size.y)) + 1
	var max_dim := maxi(map_w, map_h)
	var img_scale := 1.0
	if max_dim > 1024:
		img_scale = 1024.0 / float(max_dim)
		map_w = int(ceil(map_w * img_scale))
		map_h = int(ceil(map_h * img_scale))
	_tile_image = Image.create(map_w, map_h, false, Image.FORMAT_RGBA8)
	_tile_image.fill(BG_COLOR)
	for child in _level.get_children():
		if !(child is TileMapLayer):
			continue
		var tm := child as TileMapLayer
		for cell in tm.get_used_cells():
			var wp: Vector2 = tm.to_global(tm.map_to_local(cell))
			var ix := int((wp.x - _tile_bounds.position.x) * img_scale)
			var iy := int((wp.y - _tile_bounds.position.y) * img_scale)
			ix = clampi(ix, 0, map_w - 1)
			iy = clampi(iy, 0, map_h - 1)
			_tile_image.set_pixel(ix, iy, TILE_COLOR)
	_tile_texture = ImageTexture.create_from_image(_tile_image)

func _draw() -> void:
	var rsize := size
	if rsize.x <= 0.0 or rsize.y <= 0.0:
		return

	var bounds := _compute_bounds()
	if bounds.size.x <= 0.0 or bounds.size.y <= 0.0:
		draw_rect(Rect2(Vector2.ZERO, rsize), BG_COLOR, true)
		draw_rect(Rect2(Vector2.ZERO, rsize), BORDER_COLOR, false, 1.0)
		return

	var sx: float = rsize.x / bounds.size.x
	var sy: float = rsize.y / bounds.size.y

	draw_rect(Rect2(Vector2.ZERO, rsize), BG_COLOR, true)

	if _tile_texture != null:
		var tex_rect := Rect2(Vector2.ZERO, rsize)
		draw_texture_rect(_tile_texture, tex_rect, false)

	for t in _targets:
		if is_instance_valid(t):
			draw_circle(_to_radar(t.global_position, bounds, sx, sy), 1.5, TARGET_COLOR)
	for e in _enemies:
		if is_instance_valid(e):
			draw_circle(_to_radar(e.global_position, bounds, sx, sy), 1.5, ENEMY_COLOR)
	if is_instance_valid(_player):
		draw_circle(_to_radar(_player.global_position, bounds, sx, sy), 2.0, PLAYER_COLOR)

	draw_rect(Rect2(Vector2.ZERO, rsize), BORDER_COLOR, false, 1.0)

func _compute_bounds() -> Rect2:
	var b := Rect2()
	var has := false

	if is_instance_valid(_player):
		b = Rect2(_player.global_position, Vector2.ZERO)
		has = true

	for t in _targets:
		if is_instance_valid(t):
			if has:
				b = b.expand(t.global_position)
			else:
				b = Rect2(t.global_position, Vector2.ZERO)
				has = true
	for e in _enemies:
		if is_instance_valid(e):
			if has:
				b = b.expand(e.global_position)
			else:
				b = Rect2(e.global_position, Vector2.ZERO)
				has = true

	if _tile_texture != null:
		if has:
			b = b.merge(_tile_bounds)
		else:
			b = _tile_bounds
			has = true

	if !has:
		return Rect2()

	b = b.grow(WORLD_PADDING)
	b.size.x = maxf(b.size.x, 1.0)
	b.size.y = maxf(b.size.y, 1.0)
	return b

func _to_radar(world_pos: Vector2, bounds: Rect2, sx: float, sy: float) -> Vector2:
	return Vector2(
		(world_pos.x - bounds.position.x) * sx,
		(world_pos.y - bounds.position.y) * sy
	)