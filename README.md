# GitHub Trend Widget — MVP v2

This is a native macOS app + WidgetKit extension intended to appear in the macOS desktop widget picker.

## Architecture
- Main app fetches GitHub data and stores the latest results in an App Group.
- WidgetKit extension reads the shared cache.
- App Group: `group.com.githubtrendwidget.mvp`
- No AI dependency.
- Current trend score is a transparent proxy because GitHub Search has no historical star count.

## Run
1. Open `GitHubTrendWidget.xcodeproj` in Xcode.
2. Select the `GitHubTrendWidget` scheme.
3. Select your Mac as the run destination.
4. In Signing & Capabilities, choose your personal Apple Developer team if Xcode asks.
5. Run the app.
6. On macOS, right-click the desktop -> Edit Widgets and search for **GitHub Trend**.

If the widget does not appear after the first run, quit/relaunch the app and open the widget picker again. Widget registration is controlled by macOS and Xcode's debug install.

## Build and run without opening Xcode

From the repo root, build the app with:

- `xcodebuild -project GitHubTrendWidget.xcodeproj -scheme GitHubTrendWidget -configuration Debug -allowProvisioningUpdates build`

That command builds into Xcode's normal DerivedData location, not the local `build/` folder.

If you want a predictable output folder instead of DerivedData, use:

- `xcodebuild -project GitHubTrendWidget.xcodeproj -scheme GitHubTrendWidget -configuration Debug -derivedDataPath build -allowProvisioningUpdates build`

Only if you used `-derivedDataPath build`, launch the built app with:

- `open build/Build/Products/Debug/GitHubTrendWidget.app`

If you build without `-derivedDataPath`, you can still launch it from Xcode's default build location:

- `open ~/Library/Developer/Xcode/DerivedData/*/Build/Products/Debug/GitHubTrendWidget.app`

Notes:

- Signing still has to be configured once for your Apple Developer team.
- If the terminal says no provisioning profiles were found, build again with `-allowProvisioningUpdates` and make sure Xcode is signed into your Apple Developer account.
- If signing errors show up, open Xcode once and confirm the team under Signing & Capabilities for both targets.
- If you only want to verify that the code compiles, use `xcodebuild -project GitHubTrendWidget.xcodeproj -scheme GitHubTrendWidget -configuration Debug CODE_SIGNING_ALLOWED=NO build`.
- To rebuild from scratch, use `xcodebuild -project GitHubTrendWidget.xcodeproj -scheme GitHubTrendWidget clean build`.
- After launching the app, add the widget from the macOS widget gallery if it is not already on the desktop.

## Continue in VS Code
The project is ordinary Swift source plus an Xcode project. VS Code/Copilot can edit the same files. Use Xcode when you need to change targets, signing, capabilities, or WidgetKit configuration.

## Next feature
Add historical snapshots (stars/forks/timestamps) to calculate actual 24h and 7d growth instead of the current proxy score.
