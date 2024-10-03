# android-emulator-launcher

A launcher script for Android emulators

## Why

Having Android Emulators as standalone windows is much more convenient than seeing them in a teeny tiny pane within Android Studio, or as a second window from VSCode on Ubuntu. Plus, you might want to run a number of `adb` commands every time you launch an emulator to get you in a clean state. Finally, it's nice to have multiple launchers to launch different devices, or even device types.

## Setup

Copy and edit the conf file according to your environment (update the path to your Android `tools` folder and `AVD_NAME` according to what `emulator -list-avds` says). You can name the conf file however you prefer; you can specify it as an argument to the script later.

You can use the script like this:

```bash
./androidEmulator.sh path/to/your/androidEmulator.conf
# if your conf file is called androidEmulator.conf and is in the same folder...
./androidEmulator
```

To manage multiple devices, you can create multiple conf files (each with its own `AVD_NAME` and potentially specific options), and maybe create aliases for your shell to launch them with easy-to-remember names. For instance, in my `~/.zshrc`

```bash
alias pixel='~/git/android-emulator-launcher/androidEmulator.sh ~/pixel.conf'
alias tv='~/git/android-emulator-launcher/androidEmulator.sh ~/tv.conf'
alias nexus5='~/git/android-emulator-launcher/androidEmulator.sh ~/nexus.conf
```

So then I simply run `pixel`, `tv`, or `nexus5` to launch the specific emulator I want.

> [!NOTE]
> After the command logs `Ready!` you can kill the terminal that you launched it with; the emulator will keep running

### Ubuntu only

If you want to have a Unity Launcher for your emulators, you can copy the `.desktop` file from this repo to the folder hosting your launchers, e.g. `~/.local/share/applications`, and edit the paths according to where you're storing this repo.

## React Native specific

The script has a few `adb reverse` calls at the end that are needed to make a couple of React Native tools work. Delete them if you don't need them.

## Opinionated choices

The script sets `-no-boot-anim` to skip the initial logo, `-no-snapshot` to always run cold boots (was needed on TVs, as NFT wouldn't work and you'd get an out of sync system time, creating all sorts of issues), and `-no-snapshot-save` to silence the "do you want to save your state?" dialog when killing the emulator.
