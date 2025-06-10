#!/usr/bin/env pkgx python^3

import sys, base64, hashlib

def read_armor():
    b64 = []
    in_block = False
    for line in sys.stdin:
        if line.startswith("-----BEGIN PGP PUBLIC KEY BLOCK-----"):
            in_block = True
            continue
        if line.startswith("-----END PGP PUBLIC KEY BLOCK-----"):
            break
        if in_block:
            if not line.startswith('='):
                b64.append(line.strip())
    return base64.b64decode(''.join(b64))

def extract_pubkey_packet(blob):
    i = 0
    while i < len(blob):
        tag = blob[i]
        if tag & 0x80 == 0:
            raise ValueError("Invalid packet start")
        if not tag & 0x40:
            pkt_tag = (tag >> 2) & 0x0F
            length_type = tag & 0x03
            if length_type == 0:
                length = blob[i+1]
                llen = 1
            elif length_type == 1:
                length = int.from_bytes(blob[i+1:i+3], 'big')
                llen = 2
            elif length_type == 2:
                length = int.from_bytes(blob[i+1:i+5], 'big')
                llen = 4
            else:
                raise ValueError("Indeterminate length unsupported")
            pkt_start = i + 1 + llen
            pkt_end = pkt_start + length
            if pkt_tag == 6:
                return blob[pkt_start:pkt_end]
            i = pkt_end
        else:
            raise ValueError("New-format packets not supported here")

if __name__ == "__main__":
    blob = read_armor()
    pkt = extract_pubkey_packet(blob)
    header = b'\x99' + len(pkt).to_bytes(2, 'big')
    fp = hashlib.sha1(header + pkt).hexdigest().upper()
    long_id = fp[-16:]
    print(" ".join(long_id[i:i+4] for i in range(0, 16, 4)))