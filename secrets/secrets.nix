let
  users = {
    pekora = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOJls4HazXObD6edTR34Q4KaWgQ7fncg9dm8sCnYUBf";
    tomori = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJL8gwfkX0ql5CYkDVTq/RmEICwHLw5E+Ajb7e9czJHj";
  };
  systems = {
    soyo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAgqBgchNs+UsEIgNGFnOn4Vm7Cb0imf7ZTAX5tAoWfM";
  };
in
{
  # Private DNS records
  "private-dns-records.age".publicKeys = [
    systems.soyo
    users.pekora
    users.tomori
  ];
  # GA runner token for jungnoh/pekora-cs
  "soyo-github-runner-pekora.age".publicKeys = [ systems.soyo ];
  # Linkwarden NEXTAUTH_SECRET
  "soyo-linkwarden-nextauth.age".publicKeys = [ systems.soyo ];
  # Linkwarden POSTGRES_PASSWORD
  "soyo-linkwarden-postgres.age".publicKeys = [ systems.soyo ];
  # Backblaze B2 for backup
  "soyo-backblaze.age".publicKeys = [ systems.soyo ];
  # Forgejo registration token
  "soyo-forgejo-runner.age".publicKeys = [ systems.soyo ];
  # Gemini API
  "gemini.age".publicKeys = [
    systems.soyo
    users.tomori
  ];
  # Cloudflare Tunnel token
  "cloudflare-tunnel-token.age".publicKeys = [ systems.soyo ];
  # Cloudflare Tunnel credentials
  "cloudflare-tunnel-creds.age".publicKeys = [ systems.soyo ];
}
