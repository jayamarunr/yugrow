const fs = require('fs');
const path = require('path');

// Simple: replace ./core/theme/ with package:yugrow_mobile/core/theme/ 
// This works from any file depth.
const root = 'apps/mobile/lib';
const files = [
  'core/widgets/attendee_card.dart',
  'core/widgets/founder_mode_banner.dart',
  'features/auth/onboarding_screen.dart',
  'features/auth/signup_screen.dart',
  'features/auth/login_screen.dart',
  'features/checkin/checkin_complete_screen.dart',
  'features/checkin/home_screen.dart',
  'features/checkin/live_screen.dart',
  'features/debug/debug_screen.dart',
  'features/debug/feedback_inbox_screen.dart',
  'features/debug/founder_console_screen.dart',
  'features/events/events_screen.dart',
  'features/events/public_event_screen.dart',
  'features/host/host_event_screen.dart',
  'features/messaging/conversations_screen.dart',
  'features/messaging/message_screen.dart',
  'features/messaging/screens/connected_screen.dart',
  'features/messaging/widgets/announcement_card.dart',
  'features/messaging/widgets/feedback_status_card.dart',
  'features/messaging/widgets/message_renderer.dart',
  'features/messaging/widgets/release_message_card.dart',
  'features/network/network_screen.dart',
  'features/profile/profile_screen.dart',
  'features/profile/screens/edit_profile_screen.dart',
  'features/profile/widgets/profile_card.dart',
  'features/venue/widgets/create_venue_dialog.dart',
  'features/venue/widgets/create_venue_page.dart',
  'features/venue/widgets/location_picker_map.dart',
  'features/venue/widgets/venue_search_field.dart',
  'features/venue/widgets/venue_search_sheet.dart',
];

let count = 0;
for (const rel of files) {
  const fp = path.join(root, rel);
  let c = fs.readFileSync(fp, 'utf8');
  const oldP = "import './core/theme/";
  const newP = "import 'package:yugrow_mobile/core/theme/";
  if (c.includes(oldP)) {
    c = c.replace(new RegExp(oldP.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), newP);
    fs.writeFileSync(fp, c, 'utf8');
    count++;
    console.log('Fixed: ' + rel);
  }
}
console.log('Fixed ' + count + ' files');
