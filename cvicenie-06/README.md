# Mini-zadanie cvicenie 6
---

**Je treba updatnut celu decentralizovanu aplikaciu tak, aby bola skompilovatelna v Solidity, minimalne verzia 0.5.0 a pomocou truffle suite. Truffle-config by ste nemali mat potrebu upravit, maximalne port. Mozete testovat jednotlive smart kontrakty aj v Remixe (teoreticky tam funguju aj tie testy, ale to je lepsie robit cez truffle test).**

Teda postup je nasledovny:
- Otvorite si VSCODE, tam si to importnete (resp. vas text editor nejaky).
-	Spustite Ganache a terminal (moze byt aj priamo vo VSCODE).
-	Napisete "truffle compile" a hodi to nejake chyby - poopravujete, nieco zmenite, skontrolujete, date znovu truffle compile, dokym compile neprejde bez problemu.
-	No a potom idete na prikaz "truffle migrate", hodi chyby, tie opravujete, opravite 2_deploy_contracts.js (inspirujte sa v testoch), atd.
-	A ukoncite to "truffle test", opravite chyby, upravite testy.

**Ked vsetko ide, zabalite tak ako je a date do AIS.**

### Body: 
Update do solidity >0.5.0 tak, ze zbehne “truffle compile”, “truffle migrate” a “truffle test” = 1,5 boda
To iste co vyssie, ale update do solidity >0.6.0 = 2,5 boda
Vsetko ako v prvom bode, ale update do solidity >0.7.0 = 3 body.
