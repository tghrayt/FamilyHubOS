# FamilyOS - n8n Workflows

This folder contains n8n workflow exports for FamilyOS.

## MVP workflows

- `FAMILYOS_MAIN_00_TELEGRAM_ROUTER.json`: receives Telegram updates, enforces allowlists, normalizes interactions and routes commands/callbacks.

## Import Notes

Before importing into n8n:

1. Review each workflow JSON.
2. Configure required n8n environment variables.
3. Configure credentials in n8n, not in workflow files.
4. Import into the existing n8n instance in namespace `automation`.
5. Test with a private Telegram group and allowlisted users only.


