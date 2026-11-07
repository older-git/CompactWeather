# CompactWeather

**Temperature *and* humidity in one Apple Watch complication slot.**

Because spending two complication slots on "weather" is a crime. On the watch it's called
**CmpctWthr**.

- **Complication:** `47% 66°` in a single slot. Corner slots curve it along the bezel; circular,
  rectangular and inline slots are supported too. Humidity in cyan, temperature in white.
- **App** (tap the complication): current temperature, humidity, today's high/low, and the next
  12 hours. Opens instantly with the last forecast, then refreshes.
- Above 110 °F (43.3 °C) the screen turns red and says *"Don't ask..."*.

Weather comes from [Open-Meteo](https://open-meteo.com/): free, no account, no API key. Your
location is rounded to about 1 km before it's sent. °F or °C follows your Watch's region.

## Building

Requirements: a Mac with Xcode (Swift 6 / watchOS 10 SDK or newer) and an Apple Watch on
watchOS 10+. A free Apple developer account works, but apps signed with one expire after 7
days and need reinstalling.

1. `cp Config/Local.xcconfig.example Config/Local.xcconfig` and put in your team ID and a
   bundle ID prefix of your own.
2. Open `CompactWeather.xcodeproj`, choose your Watch as the run destination, press Run.
   (The project is generated from `project.yml` with [XcodeGen](https://github.com/yonaskolb/XcodeGen);
   run `xcodegen generate` after changing it.)
3. Open the app once and allow Location: the complication can't ask for permission itself.
4. Long-press your watch face → Edit → Complications → **CmpctWthr** → **Temp + Humidity**.

### Notes

- **Refresh:** every 30 minutes (10 after a failure), which is what watchOS reliably allows.
  Opening the app forces a redraw.
- **Build numbers bump on every build** (`Tools/bump-build-number.sh`, run as a scheme
  pre-action). watchOS keeps showing an old complication if a reinstall has the same build
  number.
- The icon is drawn by `Tools/make-icon.swift`; tweak and re-run it.

## Credits

- Weather data by [Open-Meteo.com](https://open-meteo.com/), licensed
  [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
- Spun out of [BedWatch](https://github.com/older-git/BedWatch).

## License

MIT — see [LICENSE](LICENSE).
