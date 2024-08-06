pla# Contributing

We are currently not accepting external contributions, if you find a problem with the game feel free to [open an issue](https://github.com/Degenerate-Games/shadows-below/issues/new/choose) and one of our internal team members will take a loook at it!

# Style

Below are some style guidlines for various parts of the project, these are not all inclusive so feel free to open a PR if you feel like something is missing!

## Issues

All issue titles should be as short and sweet as possible while maintaining coherence some examples are below.

- ✅ [BUG] Crash when entering dungeon on level one
- ❌ Game wont run
- ✅ Create new test level for 3D sprites
- ❌ Testing things

Issue bodies should contain more information about what is going wrong or what needs to be done and the comments should be used for conversation about that topic. When in doubt use one of the templates if it applies.

## Pull Requests

Pull Request titles should follow in a similar vein as Issue titles however they are **required** to have a [SLUG] at the beginning categorizing the issue. The options will be given at the top of the Pull Request body when it is first created, copy one of those into the title and then delete the section that has them before submitting the Pull Request.  

From there simply follow the instructions in the template to make sure that everything is in order before requesting review.

## Branches

New branches must be created when making changes as it is not possible to push directly to the `main` branch. There are two methods for creating branches:

#### Preferred

If you are creating a branch to deal with a specific Issue use the `Development` section on the issue page and keep the default name.

#### Other Situations

If there is not an open Issue and it does not make sense to open an Issue the branche's name should be an all lowercase short summary of the goal of the branch with spaces replaced with dashes (`-`). For example when creating this file there was not an open issue so the branch `add-contributing-document` was created so that changes could be made before merging into the `main` branch.

## Commits and Commit Messages

The changes made in a commit should typically be able to be summed up in less than 50 characters, of more space is needed be sure to separate the message into a summary and description in either GitHub Desktop or the CLI. Refrain from having commit messages to the effect of `Fixed a bunch of things` elect instead to explain each of those things in separate commits.

## Code Styling and File names

In general code will follow Godot's [GDScript Styling Guidelines](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html). Similarly file and folder names will follow Godot styling standards and should be in snake_case (e.g. `test.gd`, `base_level.tscn`, `player_uv.png`)