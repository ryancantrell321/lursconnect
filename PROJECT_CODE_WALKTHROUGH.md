# LURS Connect: Dart code walkthrough

This guide explains the Dart files in `lib/`. It intentionally excludes SQL. Line numbers refer to the current source files and can move if the code changes.

## Dart words used throughout the app

- `import` makes another library available in this file.
- `class` defines a new kind of object. A Flutter screen is usually a class.
- `Widget` means a piece of the visible app, such as text, a button, or a screen.
- `StatefulWidget` is a screen whose values can change while it is open. `State<...>` holds those changing values.
- `final` means a variable can be assigned once. `const` means its value is fixed and can be created at compile time.
- `?` means a value may be missing (`null`). `!` means “I expect this value not to be null.”
- `async` and `await` are used for work that takes time, such as sending a request to Supabase. `await` pauses that function until the request finishes.
- `setState` tells Flutter that a value changed and the screen should be drawn again.
- `context` is Flutter's reference to where a widget sits in the app. It is used for navigation, dialogs, screen size, and messages.
- A leading underscore, as in `_loadMembers`, marks a name private to its Dart library/file.
- `{ ... }` after a widget constructor contains named settings. Many consecutive lines in a `build` method are visual settings; their meaning is the name/value pair, and the closing brackets close the nested widgets.

## 1. App startup and navigation — `lib/main.dart`

- **Lines 1–8:** Import Flutter's UI library, splash-screen support, Supabase, local preferences, and the four app screens. These imports let this file initialize services and register pages.
- **Lines 10–14:** `main()` is the app's starting function. `ensureInitialized()` prepares Flutter before plugins are used. `preserve()` keeps the native splash image visible while startup work runs.
- **Lines 16–22:** `Supabase.initialize` connects the app to the Supabase project using its project URL and publishable client key. The app uses the Supabase Flutter package for auth and database requests.
- **Lines 24–29:** Read the locally saved `remember_me` choice and Supabase's restored login session. The first route defaults to `/login`.
- **Lines 31–44:** If Remember me was chosen and a session exists, load the user's `status` from `profiles`. If a profile exists and is not suspended, choose `/home`. A lookup error leaves the route at login.
- **Lines 46–48:** If the app will not restore the session, clear that Supabase session so the user really returns to login.
- **Line 50:** Start the Flutter application and pass in the chosen first route.
- **Lines 53–61:** `lursConnect` is the root app widget. Its `initialRoute` value tells the app which screen to open first.
- **Lines 63–74:** The root widget waits two seconds, then removes the splash screen.
- **Lines 76–91:** `MaterialApp` sets the app title, hides the debug banner, and maps route strings to screen widgets. `Navigator` can use these names to move between login, signup, password reset, and home.

## 2. Login — `lib/screens/login_screen.dart`

- **Lines 1–4:** Import Flutter widgets, shared app helpers, validation rules, Supabase auth types, and local preferences.
- **Lines 6–12:** Declare the login screen and its state class. `createState` attaches the stateful form logic to the visible screen.
- **Lines 14–17:** Create text controllers for the email and password, plus a `rememberMe` checkbox value. A controller lets code read the text a user entered.
- **Lines 19–23:** Dispose the controllers when the screen is removed. This releases resources and avoids leaving listeners alive.
- **Lines 26–31:** `signIn` stops early if either field is empty, then checks the email format. The app reports validation errors before sending a request.
- **Lines 33–38:** `signInWithPassword` asks Supabase Auth to verify the email and password. The email is trimmed to remove accidental spaces.
- **Lines 40–44:** After login, fetch the profile status using the authenticated user's ID. `single()` expects exactly one profile row.
- **Lines 46–51:** If the status is `suspended`, sign out and show a message. `mounted` checks that the screen is still open before trying to update it.
- **Lines 53–57:** Save the Remember me selection locally, then replace the login route with home.
- **Lines 58–63:** Catch authentication errors and show Supabase's explanation to the user.
- **Lines 66–112:** Build the form inside the common auth layout. It contains email, password, Remember me, Forgot Password, and Sign In controls. The checkbox updates `rememberMe` with `setState`; button callbacks call the functions above.

## 3. Signup — `lib/screens/signup_screen.dart`

- **Lines 1–4:** Import UI widgets, shared helpers, shared input validation, and Supabase's OTP/auth types.
- **Lines 7–12:** Define the signup screen and its state class.
- **Lines 14–22:** Create a controller for each free-text field: name, email, phone, birth date, student ID, password, confirmation, and email code.
- **Lines 24–29:** Keep form state: whether the user is at the code-confirmation step, whether a request is running, and which committee/year/position were selected.
- **Lines 31–59:** `years` is the committee-year menu. `positions` maps each committee type to the positions available under it. A map is a set of key/value pairs.
- **Lines 61–76:** Dispose every controller when leaving the signup screen.
- **Lines 78–97:** `signUp` prevents duplicate taps while a request is in progress, checks required text fields and dropdown choices, and stops with a message if anything is missing.
- **Lines 99–108:** Run the shared checks for name, email, phone, student ID, and password. The `??` operator uses the first non-null error, so the user sees one issue at a time.
- **Lines 110–113:** Compare the two password entries; stop if they differ.
- **Lines 115–130:** Set the loading state and call Supabase Auth's `signUp`. `data` sends the extra profile values as user metadata; it does not send the password as profile data.
- **Lines 132–142:** Confirm that Supabase did not return a logged-in session immediately. A session at this point means email confirmation is disabled, so the app signs out and asks for confirmation to be enabled.
- **Lines 144–151:** Move to the email-code screen, show a message, handle Supabase Auth errors, then turn off the loading state even if the request failed (`finally`).
- **Lines 154–180:** `verifyEmailCode` checks for a code, asks Supabase to verify it as a signup OTP, signs out after verification, and returns the user to login. The new account can then sign in normally.
- **Lines 182–200:** `resendEmailCode` asks Supabase to send another signup code. It uses the same loading/error pattern.
- **Lines 202–207:** In `build`, derive the position choices from the selected committee type. If none is chosen, the position list is empty.
- **Lines 208–240:** Build the verification-code step when `awaitingEmailCode` is true: show the destination email, code field, confirmation button, and resend button.
- **Lines 241–252:** Otherwise show basic information fields. The birth-date field is read-only and opens the shared date picker. Student ID uses a numeric keyboard.
- **Lines 253–269:** Show committee year and committee type. Changing committee type also clears the old position because it may not belong to the new committee.
- **Lines 271–282:** Show the position dropdown. It is disabled until a committee type is selected.
- **Lines 284–295:** Show password/confirmation controls and a button whose label changes during submission. The layout closes at lines 294–297.

## 4. Password reset — `lib/screens/forgot_password_screen.dart`

- **Lines 1–3:** Import Flutter widgets, Supabase auth data types, and shared helpers.
- **Lines 5–10:** Declare the reset screen and its state.
- **Lines 12–16:** Create controllers for email, verification code, new password, and password confirmation.
- **Lines 18–25:** Dispose those controllers when the screen closes.
- **Lines 28–43:** `sendCode` checks that email was entered, then asks Supabase to start password recovery. It reports success or the Auth error.
- **Lines 46–61:** Check that all reset fields exist, require at least eight password characters, and require matching passwords.
- **Lines 63–76:** Verify the recovery OTP. This temporarily creates a recovery-authenticated session, allowing `updateUser` to set the new password. The app signs out so the user signs in again with that password.
- **Lines 78–82:** Show Supabase Auth errors only while the screen is still mounted.
- **Lines 85–129:** Build the reset screen using the shared auth layout. The form has email/send-code, OTP, new password, confirmation, and reset controls. Password fields reuse the shared show/hide widget.

## 5. Home screen — `lib/screens/home_screen.dart`

- **Lines 1–4:** Import Flutter, shared helpers/colors, the background layout, and the member-list screen.
- **Lines 6–12:** Define the four home-panel cards as title/icon pairs. The `panels` list is data used later to generate the grid.
- **Lines 14–22:** Declare a stateful home screen. `_profileFuture` starts one request for the current profile and can be reused by the welcome text, drawer, and account dialog.
- **Lines 24–35:** `_loadProfile` gets the signed-in user ID. If there is no user, it returns no profile; otherwise it selects the account fields from `profiles`.
- **Lines 37–128:** `_showAccountInfo` opens a dialog. A `FutureBuilder` shows a spinner while profile data loads, an error if there is no row, or a scrollable list of profile fields when successful.
- **Lines 130–139:** `_profileValue` converts profile data to display text, supplies “Not provided” for empty values, and formats a parseable birth date.
- **Lines 141–164:** `_accountInfoRow` draws one label/value pair with spacing and a divider. `SelectableText` lets a user copy the value.
- **Lines 166–236:** `_buildDrawer` builds the side menu. It displays the profile name/email and provides Home, Account info, and Sign out actions.
- **Lines 238–248:** `_roleTitle` returns “SUPER ADMIN” when the profile has the super-admin flag. Otherwise it uses the user's position, then committee type as a fallback.
- **Lines 250–255:** `_nameFontSize` chooses a smaller font for longer names; a separate `FittedBox` also scales the welcome name to fit.
- **Lines 257–260:** `signOut` clears the Supabase session and returns to login if the widget context still exists.
- **Lines 262–284:** `openPanel` maps a dashboard title to its member `position_type` and worksheet label. The Presidential Panel is associated with “Steering”; it pushes a `MemberListScreen` onto the navigation stack.
- **Lines 286–312:** `buildPanelCard` draws one clickable panel card. The gesture calls `openPanel`; the inner column contains its icon and title.
- **Lines 314–341:** `buildAccountInfoCard` draws the single account-info card below the grid and opens the account dialog when tapped.
- **Lines 343–462:** Main `build` assembles the screen: background and drawer, top menu/logo/signout row, profile-backed welcome and role label, 2-by-2 panel grid, then account-info card. `GridView.count` turns each item in `panels` into a card.

## 6. Member list and CRUD — `lib/screens/member_list_screen.dart`

- **Lines 1–6:** Import Flutter, DFS/search, quicksort, shared Supabase helpers, and background layout.
- **Lines 8–20:** `MemberListScreen` receives `panelType` and `worksheetName`. Those values tell the shared screen which panel's rows to load and what label to show when empty.
- **Lines 22–39:** State holds the two asynchronous requests, form/search controllers, chosen sort option, and available sort labels.
- **Lines 41–46:** `initState` runs once when this screen is created and begins loading member and profile data.
- **Lines 48–57:** Dispose all text controllers when leaving the screen.
- **Lines 59–66:** `_loadMembers` asks Supabase for `members` where `position_type` equals the chosen panel, orders by name, and converts the returned rows to Dart maps.
- **Lines 68–72:** `_refreshMembers` starts a fresh load inside a synchronous `setState` callback so Flutter redraws when the future changes.
- **Lines 74–84:** `_loadProfile` fetches the current user's name, phone, and permission flags from `profiles`.
- **Lines 86–95:** `_canManage` mirrors the visible UI rules: super admins/advisors may manage all panels, while the presidential editor flag only grants access to Secretarial and Executive.
- **Lines 97–118:** `_isCurrentUser` prevents showing edit controls for a member linked to the current auth ID. If no ID is linked, it compares normalized name and phone.
- **Lines 120–141:** `_sortMembers` copies the loaded list so the original is not changed, chooses the selected field, then calls `quickSort`. Lowercasing makes text ordering ignore case; negating the comparison reverses name order.
- **Lines 143–181:** `_openEditor` fills controllers with existing values when editing, or leaves them blank for a new member. It displays the add/edit dialog and returns whether Save or Cancel was selected.
- **Lines 183–202:** Stop if the dialog was cancelled or required fields are empty. Build a map whose keys match database column names; empty year/photo become `null`.
- **Lines 204–227:** Insert a new row or update an existing ID. The update requests its ID back to confirm that RLS allowed an actual row to change. `updated_at` also helps refresh cached photos. A successful save refreshes the list; an error becomes a message.
- **Lines 229–249:** `_editorField` is a small reusable text input. The optional `phone` flag selects a phone keyboard.
- **Lines 251–276:** `_deleteMember` asks for confirmation, deletes by database ID, then refreshes. Errors are shown to the user.
- **Lines 278–344:** `_showMemberPhoto` opens a dialog with the name and image. It can zoom via `InteractiveViewer`; a missing/broken image gets a readable fallback message.
- **Lines 346–360:** `_photoUrl` returns no URL for an empty photo. If a row has an update timestamp, it adds that value to the URL as a cache-busting query parameter.
- **Lines 363–446:** `_memberCard` draws the avatar and member details. Tapping the card opens the photo. Editors see the vertical options menu unless the row is their own; menu actions call update or delete.
- **Lines 448–479:** Start the screen layout with a back button, panel title, and refresh button.
- **Lines 481–541:** Build the live search field and sort dropdown. Typing calls `setState`; changing the dropdown updates `_sortOption`, which causes a redraw.
- **Lines 543–599:** `FutureBuilder` waits for the member and profile requests. It shows loading/error/empty states, sorts the returned list, filters it using DFS search, and builds the visible cards.
- **Lines 600–627:** A second `FutureBuilder` checks permission before showing the Add member button. The database still makes the final permission decision; the UI check is for presentation only.

## 7. Iterative DFS and member search — `lib/algorithm/dfs_iterative.dart`

- **Lines 1–4:** Document that the first function traverses a graph using a stack, following the supplied C++ example.
- **Lines 5–8:** `depthFirstSearch` accepts an adjacency list and starting node. It throws an error if the start index is outside the graph.
- **Lines 10–13:** Make a `visited` flag per node, initialize the stack with the start node, make an empty traversal result, and mark the start visited.
- **Lines 15–30:** While the stack is not empty, pop its last node, add that node to the output, then examine neighbors. Invalid indexes cause an error. New neighbors are marked and pushed, preventing repeated visits.
- **Lines 33–40:** `searchMembersWithDfs` handles the app's list search. It trims/lowercases the query; an empty search returns a copy of all members.
- **Lines 42–50:** Put members on a stack in reverse order so popping preserves the original order. List the profile fields allowed in a search.
- **Lines 52–62:** Pop one member at a time, look for the query in any searchable field without case sensitivity, and collect matching members.

## 8. Quicksort — `lib/algorithm/quick_sort.dart`

- **Lines 1–5:** `quickSort` is generic: it can sort any type if the caller supplies a comparison function. Lists with fewer than two values need no work. Otherwise start sorting from first to last index.
- **Lines 8–19:** `_quickSort` stops when a section has zero/one item. It partitions the range around a pivot and recursively sorts the left and right sections.
- **Lines 21–28:** `_partition` chooses the last item as pivot and tracks the end of the items that compare less than or equal to the pivot.
- **Lines 30–37:** Walk from `low` to just before the pivot. When an item belongs before the pivot, increment the boundary and swap the two list items.
- **Lines 39–43:** Place the saved pivot just after the smaller items and return its final index.

## 9. Shared UI, Supabase client, and navigation — `lib/mechanisms/auth_helpers.dart`

- **Lines 1–3:** Import Flutter widgets, the shared background scaffold, and Supabase types.
- **Lines 5–6:** Create one shared Supabase client variable for screens to use.
- **Lines 8–10:** Define the blue accent and translucent blue card colors used across screens.
- **Lines 12–15:** `showMessage` displays short feedback at the bottom using a SnackBar.
- **Lines 17–31:** The four `goTo...` functions use named routes and replace the current route, so Back does not return to the previous auth page.
- **Lines 33–36:** `anyEmpty` checks if any supplied text controller has only whitespace or no text.
- **Lines 38–50:** `pickDate` opens Flutter's date picker; if a date is selected, it writes day/month/year into the provided controller.
- **Lines 53–63:** `buildAuthScreen` takes the screen title, content widgets, and options such as whether to show tabs. Required named parameters must be supplied by callers.
- **Lines 64–89:** Draw the reusable background, center the content, allow scrolling, display the logo, and create the rounded form card.
- **Lines 91–101:** If tabs are enabled, create Sign In/Sign Up tabs. The `...` spreads multiple widgets into the children list.
- **Lines 103–118:** Draw the title, screen-specific fields, and spacing.
- **Lines 120–131:** Choose between the auth-page footer links and a Back to Sign In link, then close the widget tree.
- **Lines 134–161:** `_buildTab` creates one tappable tab. `Expanded` shares row width evenly; the conditional styling shows which tab is active.
- **Lines 163–183:** `_buildBottomLink` displays the prompt and link appropriate for the current auth screen.
- **Lines 185–205:** `_buildBackLink` returns to sign in from a flow without tabs.
- **Lines 207–223:** `inputStyle` centralizes the label, icon, fill, and border for form fields.
- **Lines 225–244:** `buildTextField` wraps a Flutter `TextField` with spacing and optional keyboard/read-only/tap behavior.
- **Lines 246–271:** `buildDropdown` creates a typed string dropdown. It maps each string into a menu item and passes selection changes to the caller.
- **Lines 273–288:** `buildPrimaryButton` standardizes the width, height, colors, and callback for main auth buttons.
- **Lines 290–328:** `PasswordField` and its state class implement a reusable password input. `hidden` controls whether characters are obscured; tapping the eye icon flips it and `setState` redraws the field.

## 10. Shared form validation — `lib/mechanisms/auth_validator.dart`

- **Lines 1–5:** Explain that these are shared checks used before signup/login requests.
- **Lines 6–9:** Define `AuthValidator` and an email regular expression. A regular expression is a text pattern used to check format.
- **Lines 11–13:** Define the allowed name characters.
- **Lines 15–16:** Define student ID as digits only.
- **Lines 18–21:** Define acceptable Bangladesh mobile number formats. Signup removes spaces, parentheses, and hyphens before checking.
- **Lines 23–26:** Require password length and a mixture of uppercase, lowercase, number, and symbol.
- **Lines 28–35:** `name` trims spaces and returns either a helpful error string or `null` for valid input.
- **Lines 37–42:** `email` applies the email pattern.
- **Lines 44–51:** `phone` normalizes common separators, then checks the number pattern.
- **Lines 53–59:** `studentId` checks digits only.
- **Lines 61–67:** `password` checks all password conditions. Returning `null` means success; returning text means show that message.

## 11. Background layout — `lib/mechanisms/background_screen.dart`

- **Line 1:** Import Flutter's widget library.
- **Lines 3–8:** Define a reusable screen wrapper that requires a child and can optionally receive a drawer.
- **Lines 11–13:** `build` returns a `Scaffold`, which supplies the page structure and drawer support.
- **Lines 14–18:** A `Stack` layers the background image and screen content. `Positioned.fill` stretches the image to the available space.
- **Lines 20–22:** `SafeArea` keeps the screen's content clear of the status/navigation areas; `SizedBox.expand` lets the provided child use available space.

## Practical presentation notes

- The “profiles” table is separate from Supabase Auth: Auth owns login credentials, while `profiles` provides the app's member details and status.
- Signup sends profile fields as Supabase Auth metadata. The live Supabase project needs its profile-creation trigger/configuration to copy those values into `profiles`; that trigger is not part of the Dart code explained here.
- The member panel screen reads from Supabase, not directly from Google Sheets. The imported Steering and Advisory rows had no committee-year values; Secretarial and Executive were empty in the sheet at import time.
- The last reported update error was caused by the database permission function. If you have not run `202611120002_fix_member_permissions.sql` in Supabase yet, run it before demonstrating edits. That SQL is intentionally not explained in this guide.
- A safe demo is: sign in, open a panel, search, sort, open a photo, view Account info, and show an edit only after checking the Supabase permission fix and editor account.
