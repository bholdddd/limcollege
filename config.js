// lim.college: Supabase connection settings.
// Supabase → Project Settings → API (or "Data API"): copy the Project URL and the anon / publishable key.
// The anon key is designed to be public; the database's row-level security rules keep each player's data safe.
window.LIM_CONFIG = {
  supabaseUrl: "https://kcrxpsjqfhurkvbiaztt.supabase.co",          // like "https://abcdefghijklmnop.supabase.co"
  supabaseAnonKey: "sb_publishable_FWjw-auvKsic8-SETew_pw_D616x5zO"  // a long string starting with "eyJ" (or "sb_publishable_")
};
