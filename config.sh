PROJECT_NAME=PwnHub

# Enable sessions for user authentication
ENABLE_SESSIONS=true

# Security settings
MIN_PASSWORD_LENGTH=8
SESSION_TIMEOUT=3600  # 1 hour in seconds
MAX_LOGIN_ATTEMPTS=5

# Application settings
DEFAULT_USER_SPECIALTY="General CTF Player"
REQUIRE_EMAIL_VERIFICATION=false

# File upload limits
MAX_UPLOAD_SIZE=52428800  # 50MB
ALLOWED_UPLOAD_EXTENSIONS="txt,list,wordlist,dict,py,sh,md,js,php,c,cpp,java,rb,go,zip,tar,gz"

# Rate limiting
API_RATE_LIMIT=100  # requests per minute per IP
