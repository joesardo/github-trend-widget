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

## Continue in VS Code
The project is ordinary Swift source plus an Xcode project. VS Code/Copilot can edit the same files. Use Xcode when you need to change targets, signing, capabilities, or WidgetKit configuration.

## Next feature
Add historical snapshots (stars/forks/timestamps) to calculate actual 24h and 7d growth instead of the current proxy score.
# github-trend-widget
