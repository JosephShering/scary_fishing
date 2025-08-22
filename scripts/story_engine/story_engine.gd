class_name StoryEngine
extends Node

signal triggered(idx: int, event: StoryEvent)

@export var story : Story
@export var story_world : StoryWorld

var event_idx := -1

func trigger(idx: int) -> void:
    var next_event_idx := event_idx + 1
    
    if next_event_idx == idx:
        var next_event := story.events[next_event_idx]
        
        if next_event.condition_met(story_world.world):
            next_event.execute(self, story_world.world)
            triggered.emit(next_event_idx, next_event)
            event_idx += 1
