# dehashed

[![basher install](https://www.basher.it/assets/logo/basher_install.svg)](https://www.basher.it/package/)

search leaked credentials and breach data

## install

```bash
basher install gnomegl/dehashed
```

## usage

```bash
dehashed 'email:user@domain.com'
```

query dehashed database for exposed credentials.

## options

- `-f, --field` - search specific field (email, username, password, etc)
- `-p, --page` - page number (default: 1)
- `-s, --size` - results per page (max: 10000)
- `--csv` - output csv format
- `-j, --json` - raw json output

## config

```bash
export DEHASHED_API_KEY="your_key"
```

## requirements

- curl
- jq