# Pre-work - *tipsy* <sup name="a1">[1](#f1)</sup>

**Tipsy** is a tip calculator application for iOS.

Submitted by: **Tejen Patel**

Time spent: **9** hours spent in total

## User Stories

The following **required** functionality is complete:

* [X] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [X] Settings page to change the default tip percentage<sup name="a2">[2](#f2)</sup>.

The following **optional** features are implemented:
* [X] UI animations
* [X] Remembering the bill amount across app restarts (if <10mins)<sup name="a3">[3](#f3)</sup>
* [X] Using locale-specific currency and currency thousands separators<sup name="a4">[4](#f4)</sup>.
* [X] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:
* [X] **Feelin' `tipsy`? Shake your device to get a random tip amount!**
* [X] Using geolocation-specific currency. Uses GPS tracking (**harnessing iOS Location Services API**) for user's current location to determine the local currency type. #VacationMode !
* [X] Integration with iOS Settings app (iOS Settings Bundle)
* [X] Dedicated icons for Spotlight.
* [X] App icons for every device type and size.
* [X] Startup Screen for every device type and size.
* [X] **Universal app.** Compatible with all device types and sizes. Using **size classes and constraints** for every UI element and every view controller including Startup Screen view.
* [X] **Slider** to change the Tip amount! Using constraints programmatically to **make UILabel follow the UISlider** as you change the tip amount.
* [X] Split the bill with up to 10 people. Use a **UIStepper** to specify the number of people in the party.
* [X] SettingsViewController has **switches**. UISwitch events interact with each other and enable/disable each other.
* [ ] A microphone icon: tap to dictate your bill subtotal and desired tip percent. LOLLLLL Jk
* [ ] What else could ya do?

## Video Walkthrough 

#### Here's a walkthrough of implemented user stories on an *iPhone*:
<img src='https://www.tejen.net/sub/imghosting/f52297f4aab4766eaae3277cf7192284.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

Download walkthrough GIF: [x.tejen.net/hv9](http://x.tejen.net/hv9)


#### Here's a peek of auto-layouts on an *iPad Air 2 in Landscape Orientation*:
<img src='https://www.tejen.net/sub/imghosting/61f453e04bbefc93830388e1de81105e.gif' title='A quick peek on an iPad 2 Mini in Landscape Orientation, demonstration auto-layouts' width='' alt='A quick peek on an iPad 2 Mini in Landscape Orientation, demonstration auto-layouts' />

Download iPad layout demo GIF: [x.tejen.net/w4s](http://x.tejen.net/w4s)

GIFs created with [LiceCap](http://www.cockos.com/licecap/).


## Notes

Implementing iOS's Location Services framework was easier than expected. Really wanted to do this; I'm bored of making mere webapps that can't access device sensors. The complication, though, was taking the location data and performing reverse geocoding to determine the country and its currency and format. Ends up that there's a core library, CLGeocoder, that accepts a location object, reverse geocodes it, and can give me details like the Country code. From there, NSLocale was my best friend, determining currency types and formats based on country code.

The way the Tip Amount label (UILabel that contains the dollar amount of Tip) follows the slider is extremely hacky, dynamically setting a size class constraint constant equaling to the result of the equation of a line calculated from two points (the two points I used were the two extrema on an iPhone 6: the left-most and right-most slider positions and respective UILabel constraint constants). Expanding this to dramatically different screen sizes makes the UILabel look super duper offfffff from where it should be! (Should be hovering above the white nib of the slider at all times, but isn't so on super large screens like the iPad Pro). I'm sure this hacky solution can be replaced with something more *normal*, although a Google search revealed that people have serious problems implementing this properly, simply because iOS doesn't let Swift track the exact position of the white nib of UISlider elements. Technicalllyyyy, you *could* solve this by making your own slider! Butttt, I'm not quite at that level of craziness yet.

Intriguing that we weren't directed to making a Universal app with auto layout and size classes/constraints in the first place. It's like responsive design all over again, hahah. Was cool to see this play nicely with my iPad just as well as with iPhones.

Learned that making a native app isn't nearly as scary as I had always imagined! Swift, versus Objective C, makes it so much easier to hack away for hours. Size Classes and Constraints though, as incredibly useful as they do become, seem excrutiatingly painful to get right. 9 hours later, Tipsy's constraints are far from perfect. Hopefully something I can master through the CodePath course... there's probably a better way lol!

Excited for the CodePath University course! Looking forward to the opportunity with all hope.

## License

    Copyright ©2015 Tejen Hasmukh Patel

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    

## Footnotes

  <b id="f1">[1]</b> This README is based directly off of a [template](http://courses.codepath.com/snippets/intro_to_ios/readme_templates/prework_readme.md) which is provided CodePath University and intended specifically for this purpose. [↩](#a1)
  
  <b id="f2">[2]</b> Dedicating the Settings page to customization of tip amounts seemed like a slightly inefficient UX decision... that's something that'd be more easily achievable graphically on the front-end (with my UISlider solution, for example) versus empirically on a Settings page. Sooooo decided to use the Settings page for other (just as dumb) stuff instead. Lol! [↩](#a2)
  
  <b id="f3">[3]</b> I opted for making user-entered information persist for 1 hour, rather than just 10 minutes. Not like a user's gonna pay two restaurant bills in the same hour, right? Hahah [↩](#a3)

  <b id="f4">[4]</b> Comma separators are enabled on UILabels and match currency types (ie. currencies with unusual comma separation, like Indian Rupees, are supported). Comma separators are not enabled on the textbox; this is by design. [↩](#a4)
