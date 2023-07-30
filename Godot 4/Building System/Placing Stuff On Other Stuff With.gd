
# Im Skript des Spielers oder des Baurasters
func buildComponent():
	var ray_length = 100 # Länge des Raycasts

	# Führe den Raycast durch und erhalte das getroffene Objekt
	var hit_position = $Head/Camera3D/RayCast.get_collision_point()
	var hit_normal = $Head/Camera3D/RayCast.get_collision_normal()
	
	
	var normalized_normal = hit_normal.normalized()
	print(hit_position)
	print(normalized_normal)
	print("--")
	if hit_position != null:
		# Wenn der Raycast auf ein Objekt trifft
		var up_vector = Vector3.UP
		
		var look_at_transform = Transform3D()

		# Erstelle die Komponente und platziere sie an der getroffenen Position
		var new_component = load_component() # Lade die 3D-Modelldatei deiner Komponente

		# Füge die Komponente der Spielszene hinzu
		get_parent().get_node("ComponentsContainer").add_child(new_component)
		# Setze die Position der Komponente an der getroffenen Position
		new_component.global_transform.origin = Vector3( round(hit_position.x / 0.1) * 0.1,round(hit_position.y / 0.1) * 0.1,round(hit_position.z / 0.1) * 0.1)
	#	new_component.global_transform.origin = hit_position

		var look_rotation = look_at_with_y(Transform3D(), hit_normal, up_vector)
		new_component.global_transform.basis = look_rotation.basis


# Importiere die Funktion look_at_with_y
func look_at_with_y(trans, new_y, v_up):
	var look_at_transform = Transform3D()

	# Richte die hit_normal mit dem Up-Vektor aus
	var look_direction = new_y.normalized()

	# Berechne eine neue rechtsgerichtete Achse (side_direction) basierend auf der Blickrichtung und dem Up-Vektor
	var side_direction = look_direction.cross(v_up.normalized())
	if side_direction.length_squared() == 0:
		side_direction = Vector3(1, 0, 0) # Wenn side_direction null ist, setze sie auf eine Standardachse

	# Berechne die neue, korrekte Up-Achse (up_direction) basierend auf der Blickrichtung und der rechtsgerichteten Achse
	var up_direction = side_direction.cross(look_direction)

	# Erstelle eine neue Transformationsmatrix mit den ausgerichteten Achsen
	look_at_transform.basis = Basis(side_direction.normalized(), look_direction, up_direction.normalized())

	trans.basis = look_at_transform.basis
	return trans





func normalize( vec:Vector3 ):
	var newVec = vec.normalized()
	if newVec.length() < 1:
		newVec  = Vector3.UP #or whatever is your default
	return newVec