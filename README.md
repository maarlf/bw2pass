# bw2pass

A script to import passwords from a Bitwarden export file into the Pass password manager.

## Prerequisites

- jq
- Pass

## Usage

```bash
  ./bw2pass.sh path/to/bitwarden_export.json
```

## JSON Structure

The script expects the Bitwarden export file to have the following structure to be extracted:

```json
{
  "encrypted": false,
  "folders": [],
  "items": [
    {
      "name": "App",
      "login": {
        "username": "name@email.com",
        "password": "strongpassword"
      }
    }
  ]
}
```
