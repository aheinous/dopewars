extends Node

var overlay

func onNeedRedraw():
	if overlay != null:
		overlay.onNeedRedraw()