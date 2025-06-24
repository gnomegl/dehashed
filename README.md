# dehashed - Dehashed API Client

[![Basher](https://img.shields.io/badge/basher-install-brightgreen)](https://github.com/basherpm/basher)

Search leaked credentials and personal information from data breaches using the Dehashed API.

## Features

- **Comprehensive Search**: Search across multiple data breach databases
- **Multiple Field Types**: Search by email, username, password, IP, phone, and more
- **Advanced Filtering**: Use regex and wildcard patterns for complex searches
- **Flexible Output**: JSON, CSV, or formatted text output
- **Pagination Support**: Handle large result sets efficiently
- **Deduplication**: Optional result deduplication
- **Detailed Results**: Get breach source information and timestamps

## Installation

### Using Basher

```bash
basher install gnomegl/dehashed
```

### Manual Installation

```bash
git clone https://github.com/gnomegl/dehashed.git
cd dehashed
chmod +x bin/dehashed
# Add to PATH or copy to /usr/local/bin
```

## Prerequisites

You need a Dehashed API key:

1. Sign up at [Dehashed.com](https://dehashed.com/)
2. Purchase API access
3. Get your API key from the dashboard

## Configuration

Set your API key using one of these methods:

```bash
# Environment variable
export DEHASHED_API_KEY="your-api-key-here"

# Config file
mkdir -p ~/.config/dehashed
echo "your-api-key-here" > ~/.config/dehashed/api_key

# Command line option
dehashed --api-key "your-api-key-here" email:user@example.com
```

## Usage

### Basic Search

```bash
# Search by email
dehashed email:user@example.com

# Search by username
dehashed username:admin

# Search by domain
dehashed domain:example.com

# Search by IP address
dehashed ip_address:192.168.1.1
```

### Advanced Search

```bash
# Search with wildcards
dehashed "email:*@gmail.com" --wildcard

# Search with regex
dehashed "username:admin.*" --regex

# Search specific field
dehashed "john.doe" --field email

# Search with pagination
dehashed domain:example.com --page 2 --size 1000
```

### Output Formats

```bash
# JSON output
dehashed email:user@example.com --json

# CSV output
dehashed domain:example.com --csv > results.csv

# Include raw record data
dehashed email:user@example.com --show-raw
```

## Search Fields

- `email` - Email addresses
- `username` - Usernames
- `name` - Person's name
- `password` - Clear text passwords
- `hashed_password` - Hashed passwords
- `ip_address` - IP addresses
- `phone` - Phone numbers
- `address` - Physical addresses
- `social` - Social security numbers
- `domain` - Domain names
- `vin` - Vehicle identification numbers
- `license_plate` - License plate numbers
- `cryptocurrency_address` - Crypto wallet addresses

## Options

- `--api-key, -k` - Dehashed API key
- `--page, -p` - Page number for pagination
- `--size, -s` - Number of results per page (max 10000)
- `--field, -f` - Search specific field
- `--regex, -r` - Enable regex search
- `--wildcard, -w` - Enable wildcard search
- `--no-dedupe` - Disable result deduplication
- `--json, -j` - Output raw JSON
- `--csv` - Output CSV format
- `--quiet, -q` - Suppress colored output
- `--no-header` - Don't display header information
- `--show-raw` - Include raw record data

## Examples

```bash
# Find all Gmail addresses in breaches
dehashed "email:*@gmail.com" --wildcard --size 5000

# Search for admin accounts
dehashed "username:admin*" --wildcard

# Find breaches containing specific company
dehashed domain:company.com --size 1000

# Search for phone numbers in specific area code
dehashed "phone:555*" --wildcard

# Complex search with multiple criteria
dehashed "name:John Doe" --field name --size 100

# Export large dataset to CSV
dehashed domain:target.com --csv --size 10000 > breach_data.csv
```

## Understanding Results

Each result includes:
- **Database Name**: Source breach database
- **Personal Information**: Names, emails, usernames
- **Credentials**: Passwords (hashed and clear text)
- **Contact Information**: Phone numbers, addresses
- **Technical Data**: IP addresses, cryptocurrency addresses
- **Timestamps**: When the data was collected

## Security Considerations

- **Responsible Use**: Only use for legitimate security research
- **Data Sensitivity**: Handle results with appropriate security measures
- **Legal Compliance**: Ensure compliance with local laws and regulations
- **Ethical Guidelines**: Follow responsible disclosure practices

## Requirements

- `curl` - For API requests
- `jq` - For JSON processing

## API Limits

Dehashed API limits depend on your subscription plan. The tool displays:
- Current balance (credits remaining)
- Query execution time
- Total results found

## License

MIT License
