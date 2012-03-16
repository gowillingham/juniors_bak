INHOUSE_LEAGUE_FIRST_SESSION_DATE = '2012-04-14'.to_date

APP_LONG_NAME = "Lakeville Junior Volleyball"
APP_SHORT_NAME = "Lakeville Juniors"
APP_HOST_NAME = "lakevillejuniors.com"

INFO_EMAIL_ADDRESS = "info@lakevillejuniors.com"
ADMIN_EMAIL_ADDRESS = "willingham@lakevillejuniors.com"
OWNER_EMAIL_ADDRESS = "gowillingham@gmail.com"
REPORT_TO_EMAIL_LIST = ['willingham@lakevillejuniors.com', 'info@lakevillejuniors.com']

PAYPAL_COMPLETED = 'Completed'
PAYPAL_PENDING = 'Pending'
PAYPAL_FAILED = 'Failed'

APP_ADDRESS = {
  :street => '21266 Inspiration Path',
  :city_state_zip => 'Lakeville, MN 55044'
}
APP_PHONE = '952-431-6341'

SCHOOL_OPTIONS = [
  ['All Saints', 'ASE'], 
  ['Cherryview', 'CVE'], 
  ['Christina Huddleston', 'CHE'], 
  ['Crystal Lake', 'CLE'], 
  ['Eastview', 'EVE'], 
  ['John F Kennedy', 'JFK'], 
  ['Lake Marion', 'LME'], 
  ['Lakeview', 'LVE'], 
  ['Oak Hills', 'OHE'], 
  ['Orchard Lake', 'OLE'], 
  ["My school's not listed ..", 'NA']
]

SIZE_OPTIONS = [
  ['YS - Youth small', 'YS'], 
  ['YM - Youth medium', 'YM'], 
  ['YL - Youth large', 'YL'], 
  ['S - Adult small', 'S'], 
  ['M - Adult medium', 'M'], 
  ['L - Adult large', 'L'], 
  ['XL - Adult X-large', 'XL'], 
  ['XXL - Adult XX-large', 'XXL']
]

SESSION_OPTIONS = [
  ['Session I Beginner (grade 1-3)', 1], 
  ['Session II Intermediate (grade 3-6)', 2]
]

GRADE_OPTIONS = (1..6).map { |i| [i,i] }  


