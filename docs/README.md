# He thong quan tri ha tang GreenTech K26

## Cach chay script loc log

Tu thu muc goc repository:

```bat
scripts\auto_report.bat
```

Script doc `data/log-he-thong.log`, loc cac dong `CRITICAL`, `ERROR 404`, `TIMEOUT` va ghi noi vao `backup/bao-cao-su-co.txt`.

## Checklist kiem tra thiet bi

- [ ] Kiem tra ket noi tram cam bien.
- [ ] Kiem tra dung luong RAM con trong.
- [ ] Doi chieu ma linh kien voi danh muc.
- [ ] Sao luu bao cao vao `backup/`.
- [ ] Xac nhan `.env` khong duoc commit.

## Thong so mau

| Tram | CPU | RAM | Storage | Ngay lap dat |
|---|---|---:|---|---|
| TRAM-001 | Intel N100 | 4 GB | SSD 500GB | 2025-01-15 |
| TRAM-002 | Intel Core i3-12100 | 8 GB | SSD 1TB | 2025-01-18 |
| TRAM-003 | AMD Ryzen 5 5600G | 16 GB | SSD 1TB | 2025-01-21 |

## Chuan hoa du lieu

Dung `TRIM` truoc khi `VLOOKUP`, su dung `FALSE` de tim khop chinh xac va co dinh vung danh muc bang dau `$`.
