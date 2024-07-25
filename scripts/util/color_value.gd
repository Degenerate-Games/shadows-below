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
