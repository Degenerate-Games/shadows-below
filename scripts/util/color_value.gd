#	Copyright 2024 Degenerate Games
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#		http://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.

class_name ColorValue

var value: int:
	get:
		return value
	set(val):
		value = clamp(val, 0, steps)
var steps: int

func _init(val: int, num_steps: int = 255):
	self.steps = num_steps
	self.value = val

func increment():
	self.value += 1

func decrement():
	self.value -= 1

func add(val: int):
	self.value += val

func subtract(val: int):
	self.value -= val

func invert():
	return ColorValue.new(255 - self.value)

func normalize():
	return remap(self.value, 0, steps, 0.25, 1.0)
