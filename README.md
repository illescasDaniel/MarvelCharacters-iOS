# Marvel Characters demo app

Mini app that uses marvel characters api to display and search marvel characters.

## Features
- Display a sorted list of characters
- Change list order
- Display characters details
- Search by charcter name
- Caching mechanisms for faster data loading
- Usage of the new storyboards API
- Usage of the new diffable data source API for tableView (available right now in the branch: feature/diffableDataSource)

## Installation [IMPORTANT]

0. Follow this steps before opening the project (if possible).
1. This app uses the official marvel api: https://developer.marvel.com/docs
2. To setup the project, **you need to get the marvel api developer keys AND add "\*" in "Your authorized referrers" (https://developer.marvel.com/account)**.
3. Then you simply need to run the script "set_up_keys.sh", it will ask you the public and private api keys. Once you enter those details a new file named "Keys.xcconfig" will be generated and you will be able to compile the project. Note: if you have any issues regarding this, just delete the existing Keys.xcconfig entry in Xcode and create the file again using the script or by yourself. You have an example in the file "Marvel Character/config/Keys.example.xcconfig".
4. There is only one external dependency, ZippyJSON, but is should load automatically with the Swift Package Manager

## Extra

- There is a development branch featuring the new [diffable Apple API](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource), named 'feature/diffableDataSources'.

## Screenshots

<p float="left">
  <img src="github/CharactersList.PNG" width="300">
  <img src="github/CharactersSearch.PNG" width="300">
  <img src="github/CharacterDetail.PNG" width="300">
</p>

### Credits
- [Icons](https://icons8.com/icon/pack/cinema/color): Some icons used for the app icon.
- [ZippyJSON](https://github.com/michaeleisel/ZippyJSON): Used for faster JSON decoding (only works on real devices, when using simulator it uses the standard JSONDecoder from Apple).
- Some articles that helped:
  - https://medium.com/@alfianlosari/using-diffable-data-source-ios-13-api-in-uitableview-47343c2332be
  - https://stephenradford.me/make-uilabel-copyable/

