-- ZPU
--
-- Copyright 2004-2008 oharboe - �yvind Harboe - oyvind.harboe@zylin.com
-- Modified by Alastair M. Robinson for the ZPUFlex project.
--
-- The FreeBSD license
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
-- 
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above
--    copyright notice, this list of conditions and the following
--    disclaimer in the documentation and/or other materials
--    provided with the distribution.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE ZPU PROJECT ``AS IS'' AND ANY
-- EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
-- PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
-- ZPU PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
-- INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
-- STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
-- ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 
-- The views and conclusions contained in the software and documentation
-- are those of the authors and should not be interpreted as representing
-- official policies, either expressed or implied, of the ZPU Project.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.zpu_config.all;
use work.zpupkg.all;

entity Dhrystone_fast_ROM is
generic
	(
		maxAddrBitBRAM : integer := maxAddrBitBRAMLimit -- Specify your actual ROM size to save LEs and unnecessary block RAM usage.
	);
port (
	clk : in std_logic;
	areset : in std_logic := '0';
	from_zpu : in ZPU_ToROM;
	to_zpu : out ZPU_FromROM
);
end Dhrystone_fast_ROM;

architecture arch of Dhrystone_fast_ROM is

type ram_type is array(natural range 0 to ((2**(maxAddrBitBRAM+1))/4)-1) of std_logic_vector(wordSize-1 downto 0);

shared variable ram : ram_type :=
(
     0 => x"0b0b0b88",
     1 => x"dd040000",
     2 => x"00000000",
     3 => x"00000000",
     4 => x"00000000",
     5 => x"00000000",
     6 => x"00000000",
     7 => x"00000000",
     8 => x"88088c08",
     9 => x"90080b0b",
    10 => x"0b88e708",
    11 => x"2d900c8c",
    12 => x"0c880c04",
    13 => x"00000000",
    14 => x"00000000",
    15 => x"00000000",
    16 => x"71fd0608",
    17 => x"72830609",
    18 => x"81058205",
    19 => x"832b2a83",
    20 => x"ffff0652",
    21 => x"04000000",
    22 => x"00000000",
    23 => x"00000000",
    24 => x"71fd0608",
    25 => x"83ffff73",
    26 => x"83060981",
    27 => x"05820583",
    28 => x"2b2b0906",
    29 => x"7383ffff",
    30 => x"0b0b0b0b",
    31 => x"83a50400",
    32 => x"72098105",
    33 => x"72057373",
    34 => x"09060906",
    35 => x"73097306",
    36 => x"070a8106",
    37 => x"53510400",
    38 => x"00000000",
    39 => x"00000000",
    40 => x"72722473",
    41 => x"732e0753",
    42 => x"51040000",
    43 => x"00000000",
    44 => x"00000000",
    45 => x"00000000",
    46 => x"00000000",
    47 => x"00000000",
    48 => x"71737109",
    49 => x"71068106",
    50 => x"09810572",
    51 => x"0a100a72",
    52 => x"0a100a31",
    53 => x"050a8106",
    54 => x"51515351",
    55 => x"04000000",
    56 => x"72722673",
    57 => x"732e0753",
    58 => x"51040000",
    59 => x"00000000",
    60 => x"00000000",
    61 => x"00000000",
    62 => x"00000000",
    63 => x"00000000",
    64 => x"00000000",
    65 => x"00000000",
    66 => x"00000000",
    67 => x"00000000",
    68 => x"00000000",
    69 => x"00000000",
    70 => x"00000000",
    71 => x"00000000",
    72 => x"0b0b0b88",
    73 => x"ba040000",
    74 => x"00000000",
    75 => x"00000000",
    76 => x"00000000",
    77 => x"00000000",
    78 => x"00000000",
    79 => x"00000000",
    80 => x"720a722b",
    81 => x"0a535104",
    82 => x"00000000",
    83 => x"00000000",
    84 => x"00000000",
    85 => x"00000000",
    86 => x"00000000",
    87 => x"00000000",
    88 => x"72729f06",
    89 => x"0981050b",
    90 => x"0b0b889f",
    91 => x"05040000",
    92 => x"00000000",
    93 => x"00000000",
    94 => x"00000000",
    95 => x"00000000",
    96 => x"72722aff",
    97 => x"739f062a",
    98 => x"0974090a",
    99 => x"8106ff05",
   100 => x"06075351",
   101 => x"04000000",
   102 => x"00000000",
   103 => x"00000000",
   104 => x"71715351",
   105 => x"04067383",
   106 => x"06098105",
   107 => x"8205832b",
   108 => x"0b2b0772",
   109 => x"fc060c51",
   110 => x"51040000",
   111 => x"00000000",
   112 => x"72098105",
   113 => x"72050970",
   114 => x"81050906",
   115 => x"0a810653",
   116 => x"51040000",
   117 => x"00000000",
   118 => x"00000000",
   119 => x"00000000",
   120 => x"72098105",
   121 => x"72050970",
   122 => x"81050906",
   123 => x"0a098106",
   124 => x"53510400",
   125 => x"00000000",
   126 => x"00000000",
   127 => x"00000000",
   128 => x"71098105",
   129 => x"52040000",
   130 => x"00000000",
   131 => x"00000000",
   132 => x"00000000",
   133 => x"00000000",
   134 => x"00000000",
   135 => x"00000000",
   136 => x"72720981",
   137 => x"05055351",
   138 => x"04000000",
   139 => x"00000000",
   140 => x"00000000",
   141 => x"00000000",
   142 => x"00000000",
   143 => x"00000000",
   144 => x"72097206",
   145 => x"73730906",
   146 => x"07535104",
   147 => x"00000000",
   148 => x"00000000",
   149 => x"00000000",
   150 => x"00000000",
   151 => x"00000000",
   152 => x"71fc0608",
   153 => x"72830609",
   154 => x"81058305",
   155 => x"1010102a",
   156 => x"81ff0652",
   157 => x"04000000",
   158 => x"00000000",
   159 => x"00000000",
   160 => x"71fc0608",
   161 => x"0b0b0ba0",
   162 => x"dc738306",
   163 => x"10100508",
   164 => x"060b0b0b",
   165 => x"88a20400",
   166 => x"00000000",
   167 => x"00000000",
   168 => x"88088c08",
   169 => x"90087575",
   170 => x"0b0b0b99",
   171 => x"cf2d5050",
   172 => x"88085690",
   173 => x"0c8c0c88",
   174 => x"0c510400",
   175 => x"00000000",
   176 => x"88088c08",
   177 => x"90087575",
   178 => x"0b0b0b9b",
   179 => x"812d5050",
   180 => x"88085690",
   181 => x"0c8c0c88",
   182 => x"0c510400",
   183 => x"00000000",
   184 => x"72097081",
   185 => x"0509060a",
   186 => x"8106ff05",
   187 => x"70547106",
   188 => x"73097274",
   189 => x"05ff0506",
   190 => x"07515151",
   191 => x"04000000",
   192 => x"72097081",
   193 => x"0509060a",
   194 => x"098106ff",
   195 => x"05705471",
   196 => x"06730972",
   197 => x"7405ff05",
   198 => x"06075151",
   199 => x"51040000",
   200 => x"05ff0504",
   201 => x"00000000",
   202 => x"00000000",
   203 => x"00000000",
   204 => x"00000000",
   205 => x"00000000",
   206 => x"00000000",
   207 => x"00000000",
   208 => x"04000000",
   209 => x"00000000",
   210 => x"00000000",
   211 => x"00000000",
   212 => x"00000000",
   213 => x"00000000",
   214 => x"00000000",
   215 => x"00000000",
   216 => x"71810552",
   217 => x"04000000",
   218 => x"00000000",
   219 => x"00000000",
   220 => x"00000000",
   221 => x"00000000",
   222 => x"00000000",
   223 => x"00000000",
   224 => x"00000000",
   225 => x"00000000",
   226 => x"00000000",
   227 => x"00000000",
   228 => x"00000000",
   229 => x"00000000",
   230 => x"00000000",
   231 => x"00000000",
   232 => x"02840572",
   233 => x"10100552",
   234 => x"04000000",
   235 => x"00000000",
   236 => x"00000000",
   237 => x"00000000",
   238 => x"00000000",
   239 => x"00000000",
   240 => x"00000000",
   241 => x"00000000",
   242 => x"00000000",
   243 => x"00000000",
   244 => x"00000000",
   245 => x"00000000",
   246 => x"00000000",
   247 => x"00000000",
   248 => x"717105ff",
   249 => x"05715351",
   250 => x"020d0400",
   251 => x"00000000",
   252 => x"00000000",
   253 => x"00000000",
   254 => x"00000000",
   255 => x"00000000",
   256 => x"10101010",
   257 => x"10101010",
   258 => x"10101010",
   259 => x"10101010",
   260 => x"10101010",
   261 => x"10101010",
   262 => x"10101010",
   263 => x"10101053",
   264 => x"51047381",
   265 => x"ff067383",
   266 => x"06098105",
   267 => x"83051010",
   268 => x"102b0772",
   269 => x"fc060c51",
   270 => x"51047272",
   271 => x"80728106",
   272 => x"ff050972",
   273 => x"06057110",
   274 => x"52720a10",
   275 => x"0a5372ed",
   276 => x"38515153",
   277 => x"51040000",
   278 => x"800488da",
   279 => x"0488da0b",
   280 => x"8fc70404",
   281 => x"00000000",
   282 => x"00046302",
   283 => x"c0050d02",
   284 => x"80c4050b",
   285 => x"0b0ba684",
   286 => x"5a5c807c",
   287 => x"7084055e",
   288 => x"08715f5f",
   289 => x"577d7084",
   290 => x"055f0856",
   291 => x"80587598",
   292 => x"2a76882b",
   293 => x"57557480",
   294 => x"2e82d338",
   295 => x"7c802eb9",
   296 => x"38805d74",
   297 => x"80e42e81",
   298 => x"9f387480",
   299 => x"e42680dc",
   300 => x"387480e3",
   301 => x"2eba38a5",
   302 => x"518c842d",
   303 => x"74518c84",
   304 => x"2d821757",
   305 => x"81185883",
   306 => x"7825c338",
   307 => x"74ffb638",
   308 => x"7e880c02",
   309 => x"80c0050d",
   310 => x"0474a52e",
   311 => x"09810698",
   312 => x"38810b81",
   313 => x"19595d83",
   314 => x"7825ffa2",
   315 => x"3889cc04",
   316 => x"7b841d71",
   317 => x"08575d5a",
   318 => x"74518c84",
   319 => x"2d811781",
   320 => x"19595783",
   321 => x"7825ff86",
   322 => x"3889cc04",
   323 => x"7480f32e",
   324 => x"098106ff",
   325 => x"a2387b84",
   326 => x"1d710870",
   327 => x"545b5d54",
   328 => x"8ca52d80",
   329 => x"0bff1155",
   330 => x"53807325",
   331 => x"ff963878",
   332 => x"7081055a",
   333 => x"84e02d70",
   334 => x"52558c84",
   335 => x"2d811774",
   336 => x"ff165654",
   337 => x"578aa904",
   338 => x"7b841d71",
   339 => x"080b0b0b",
   340 => x"a6840b0b",
   341 => x"0b0ba5b4",
   342 => x"615f585e",
   343 => x"525d5380",
   344 => x"73248193",
   345 => x"3872ba38",
   346 => x"b00b0b0b",
   347 => x"0ba5b40b",
   348 => x"85802d81",
   349 => x"1454ff14",
   350 => x"547384e0",
   351 => x"2d7b7081",
   352 => x"055d8580",
   353 => x"2d811a5a",
   354 => x"730b0b0b",
   355 => x"a5b42e09",
   356 => x"8106e338",
   357 => x"807b8580",
   358 => x"2d79ff11",
   359 => x"55538aa9",
   360 => x"048a5272",
   361 => x"519b812d",
   362 => x"8808a0ec",
   363 => x"0584e02d",
   364 => x"74708105",
   365 => x"5685802d",
   366 => x"8a527251",
   367 => x"99cf2d88",
   368 => x"08538808",
   369 => x"dc38730b",
   370 => x"0b0ba5b4",
   371 => x"2ec638ff",
   372 => x"14547384",
   373 => x"e02d7b70",
   374 => x"81055d85",
   375 => x"802d811a",
   376 => x"5a730b0b",
   377 => x"0ba5b42e",
   378 => x"ffaa388a",
   379 => x"f6047688",
   380 => x"0c0280c0",
   381 => x"050d04ad",
   382 => x"518c842d",
   383 => x"72098105",
   384 => x"538ae504",
   385 => x"02f8050d",
   386 => x"7352c008",
   387 => x"70882a70",
   388 => x"81065151",
   389 => x"5170802e",
   390 => x"f13871c0",
   391 => x"0c71880c",
   392 => x"0288050d",
   393 => x"0402e805",
   394 => x"0d807857",
   395 => x"55757084",
   396 => x"05570853",
   397 => x"80547298",
   398 => x"2a73882b",
   399 => x"54527180",
   400 => x"2ea238c0",
   401 => x"0870882a",
   402 => x"70810651",
   403 => x"51517080",
   404 => x"2ef13871",
   405 => x"c00c8115",
   406 => x"81155555",
   407 => x"837425d6",
   408 => x"3871ca38",
   409 => x"74880c02",
   410 => x"98050d04",
   411 => x"c808880c",
   412 => x"0402fc05",
   413 => x"0d80c10b",
   414 => x"80f5d00b",
   415 => x"85802d80",
   416 => x"0b80f7e8",
   417 => x"0c70880c",
   418 => x"0284050d",
   419 => x"0402f805",
   420 => x"0d800b80",
   421 => x"f5d00b84",
   422 => x"e02d5252",
   423 => x"7080c12e",
   424 => x"9d387180",
   425 => x"f7e80807",
   426 => x"80f7e80c",
   427 => x"80c20b80",
   428 => x"f5d40b85",
   429 => x"802d7088",
   430 => x"0c028805",
   431 => x"0d04810b",
   432 => x"80f7e808",
   433 => x"0780f7e8",
   434 => x"0c80c20b",
   435 => x"80f5d40b",
   436 => x"85802d70",
   437 => x"880c0288",
   438 => x"050d0402",
   439 => x"f0050d75",
   440 => x"70088a05",
   441 => x"535380f5",
   442 => x"d00b84e0",
   443 => x"2d517080",
   444 => x"c12e8c38",
   445 => x"73f03870",
   446 => x"880c0290",
   447 => x"050d04ff",
   448 => x"127080f5",
   449 => x"cc083174",
   450 => x"0c880c02",
   451 => x"90050d04",
   452 => x"02ec050d",
   453 => x"80f5f808",
   454 => x"5574802e",
   455 => x"8c387675",
   456 => x"08710c80",
   457 => x"f5f80856",
   458 => x"548c1553",
   459 => x"80f5cc08",
   460 => x"528a5197",
   461 => x"a52d7388",
   462 => x"0c029405",
   463 => x"0d0402e8",
   464 => x"050d7770",
   465 => x"085656b0",
   466 => x"5380f5f8",
   467 => x"08527451",
   468 => x"9ead2d85",
   469 => x"0b8c170c",
   470 => x"850b8c16",
   471 => x"0c750875",
   472 => x"0c80f5f8",
   473 => x"08547380",
   474 => x"2e8a3873",
   475 => x"08750c80",
   476 => x"f5f80854",
   477 => x"8c145380",
   478 => x"f5cc0852",
   479 => x"8a5197a5",
   480 => x"2d841508",
   481 => x"ae38860b",
   482 => x"8c160c88",
   483 => x"15528816",
   484 => x"085196bf",
   485 => x"2d80f5f8",
   486 => x"08700876",
   487 => x"0c548c15",
   488 => x"7054548a",
   489 => x"52730851",
   490 => x"97a52d73",
   491 => x"880c0298",
   492 => x"050d0475",
   493 => x"0854b053",
   494 => x"73527551",
   495 => x"9ead2d73",
   496 => x"880c0298",
   497 => x"050d0402",
   498 => x"c8050d80",
   499 => x"f4e40b80",
   500 => x"f5980c80",
   501 => x"f59c0b80",
   502 => x"f5f80c80",
   503 => x"f4e40b80",
   504 => x"f59c0c80",
   505 => x"0b80f59c",
   506 => x"0b84050c",
   507 => x"820b80f5",
   508 => x"9c0b8805",
   509 => x"0ca80b80",
   510 => x"f59c0b8c",
   511 => x"050c9f53",
   512 => x"a1805280",
   513 => x"f5ac519e",
   514 => x"ad2d9f53",
   515 => x"a1a05280",
   516 => x"f7c8519e",
   517 => x"ad2d8a0b",
   518 => x"b3b00ca4",
   519 => x"805188eb",
   520 => x"2da1c051",
   521 => x"88eb2da4",
   522 => x"805188eb",
   523 => x"2da5b008",
   524 => x"802e8491",
   525 => x"38a1f051",
   526 => x"88eb2da4",
   527 => x"805188eb",
   528 => x"2da5ac08",
   529 => x"52a29c51",
   530 => x"88eb2dc8",
   531 => x"0870a6d0",
   532 => x"0c568158",
   533 => x"800ba5ac",
   534 => x"082582dc",
   535 => x"3802ac05",
   536 => x"5b80c10b",
   537 => x"80f5d00b",
   538 => x"85802d81",
   539 => x"0b80f7e8",
   540 => x"0c80c20b",
   541 => x"80f5d40b",
   542 => x"85802d82",
   543 => x"5c835a9f",
   544 => x"53a2cc52",
   545 => x"80f5d851",
   546 => x"9ead2d81",
   547 => x"5d800b80",
   548 => x"f5d85380",
   549 => x"f7c85255",
   550 => x"98d72d88",
   551 => x"08752e09",
   552 => x"81068338",
   553 => x"81557480",
   554 => x"f7e80c7b",
   555 => x"70575574",
   556 => x"8325a138",
   557 => x"74101015",
   558 => x"fd055e02",
   559 => x"b805fc05",
   560 => x"53835275",
   561 => x"5197a52d",
   562 => x"811c705d",
   563 => x"70575583",
   564 => x"7524e138",
   565 => x"7d547453",
   566 => x"a6d45280",
   567 => x"f6805197",
   568 => x"b72d80f5",
   569 => x"f8087008",
   570 => x"5757b053",
   571 => x"76527551",
   572 => x"9ead2d85",
   573 => x"0b8c180c",
   574 => x"850b8c17",
   575 => x"0c760876",
   576 => x"0c80f5f8",
   577 => x"08557480",
   578 => x"2e8a3874",
   579 => x"08760c80",
   580 => x"f5f80855",
   581 => x"8c155380",
   582 => x"f5cc0852",
   583 => x"8a5197a5",
   584 => x"2d841608",
   585 => x"83d83886",
   586 => x"0b8c170c",
   587 => x"88165288",
   588 => x"17085196",
   589 => x"bf2d80f5",
   590 => x"f8087008",
   591 => x"770c578c",
   592 => x"16705455",
   593 => x"8a527408",
   594 => x"5197a52d",
   595 => x"80c10b80",
   596 => x"f5d40b84",
   597 => x"e02d5656",
   598 => x"757526a5",
   599 => x"3880c352",
   600 => x"755198a3",
   601 => x"2d88087d",
   602 => x"2e82e238",
   603 => x"81167081",
   604 => x"ff0680f5",
   605 => x"d40b84e0",
   606 => x"2d525755",
   607 => x"747627dd",
   608 => x"38797c29",
   609 => x"7e535199",
   610 => x"cf2d8808",
   611 => x"5c88088a",
   612 => x"0580f5d0",
   613 => x"0b84e02d",
   614 => x"80f5cc08",
   615 => x"59575575",
   616 => x"80c12e82",
   617 => x"f43878f7",
   618 => x"38811858",
   619 => x"a5ac0878",
   620 => x"25fdae38",
   621 => x"a6d00856",
   622 => x"c8087080",
   623 => x"f5940c70",
   624 => x"773170a6",
   625 => x"cc0c53a2",
   626 => x"ec525b88",
   627 => x"eb2da6cc",
   628 => x"085680f7",
   629 => x"762580f3",
   630 => x"38a5ac08",
   631 => x"70537687",
   632 => x"e829525a",
   633 => x"99cf2d88",
   634 => x"08a6c40c",
   635 => x"75527987",
   636 => x"e8295199",
   637 => x"cf2d8808",
   638 => x"a6c80c75",
   639 => x"527984b9",
   640 => x"295199cf",
   641 => x"2d880880",
   642 => x"f5fc0ca2",
   643 => x"fc5188eb",
   644 => x"2da6c408",
   645 => x"52a3ac51",
   646 => x"88eb2da3",
   647 => x"b45188eb",
   648 => x"2da6c808",
   649 => x"52a3ac51",
   650 => x"88eb2d80",
   651 => x"f5fc0852",
   652 => x"a3e45188",
   653 => x"eb2da480",
   654 => x"5188eb2d",
   655 => x"800b880c",
   656 => x"02b8050d",
   657 => x"04a48451",
   658 => x"90b804a4",
   659 => x"b45188eb",
   660 => x"2da4ec51",
   661 => x"88eb2da4",
   662 => x"805188eb",
   663 => x"2da6cc08",
   664 => x"a5ac0870",
   665 => x"547187e8",
   666 => x"29535b56",
   667 => x"99cf2d88",
   668 => x"08a6c40c",
   669 => x"75527987",
   670 => x"e8295199",
   671 => x"cf2d8808",
   672 => x"a6c80c75",
   673 => x"527984b9",
   674 => x"295199cf",
   675 => x"2d880880",
   676 => x"f5fc0ca2",
   677 => x"fc5188eb",
   678 => x"2da6c408",
   679 => x"52a3ac51",
   680 => x"88eb2da3",
   681 => x"b45188eb",
   682 => x"2da6c808",
   683 => x"52a3ac51",
   684 => x"88eb2d80",
   685 => x"f5fc0852",
   686 => x"a3e45188",
   687 => x"eb2da480",
   688 => x"5188eb2d",
   689 => x"800b880c",
   690 => x"02b8050d",
   691 => x"0402b805",
   692 => x"f8055280",
   693 => x"5196bf2d",
   694 => x"9f53a58c",
   695 => x"5280f5d8",
   696 => x"519ead2d",
   697 => x"777880f5",
   698 => x"cc0c8117",
   699 => x"7081ff06",
   700 => x"80f5d40b",
   701 => x"84e02d52",
   702 => x"58565a92",
   703 => x"fc047608",
   704 => x"56b05375",
   705 => x"5276519e",
   706 => x"ad2d80c1",
   707 => x"0b80f5d4",
   708 => x"0b84e02d",
   709 => x"565692d8",
   710 => x"04ff1570",
   711 => x"78317c0c",
   712 => x"59805993",
   713 => x"a90402f8",
   714 => x"050d7382",
   715 => x"32700981",
   716 => x"05707207",
   717 => x"8025880c",
   718 => x"52520288",
   719 => x"050d0402",
   720 => x"f4050d74",
   721 => x"76715354",
   722 => x"5271822e",
   723 => x"83388351",
   724 => x"71812e9b",
   725 => x"38817226",
   726 => x"a0387182",
   727 => x"2ebc3871",
   728 => x"842eac38",
   729 => x"70730c70",
   730 => x"880c028c",
   731 => x"050d0480",
   732 => x"e40b80f5",
   733 => x"cc08258c",
   734 => x"3880730c",
   735 => x"70880c02",
   736 => x"8c050d04",
   737 => x"83730c70",
   738 => x"880c028c",
   739 => x"050d0482",
   740 => x"730c7088",
   741 => x"0c028c05",
   742 => x"0d048173",
   743 => x"0c70880c",
   744 => x"028c050d",
   745 => x"0402fc05",
   746 => x"0d747414",
   747 => x"8205710c",
   748 => x"880c0284",
   749 => x"050d0402",
   750 => x"d8050d7b",
   751 => x"7d7f6185",
   752 => x"1270822b",
   753 => x"75117074",
   754 => x"71708405",
   755 => x"530c5a5a",
   756 => x"5d5b760c",
   757 => x"7980f818",
   758 => x"0c798612",
   759 => x"5257585a",
   760 => x"5a767624",
   761 => x"993876b3",
   762 => x"29822b79",
   763 => x"11515376",
   764 => x"73708405",
   765 => x"550c8114",
   766 => x"54757425",
   767 => x"f2387681",
   768 => x"cc2919fc",
   769 => x"11088105",
   770 => x"fc120c7a",
   771 => x"1970089f",
   772 => x"a0130c58",
   773 => x"56850b80",
   774 => x"f5cc0c75",
   775 => x"880c02a8",
   776 => x"050d0402",
   777 => x"f4050d02",
   778 => x"930584e0",
   779 => x"2d518002",
   780 => x"84059705",
   781 => x"84e02d54",
   782 => x"5270732e",
   783 => x"89387188",
   784 => x"0c028c05",
   785 => x"0d047080",
   786 => x"f5d00b85",
   787 => x"802d810b",
   788 => x"880c028c",
   789 => x"050d0402",
   790 => x"dc050d7a",
   791 => x"7c595682",
   792 => x"0b831955",
   793 => x"55741670",
   794 => x"84e02d75",
   795 => x"84e02d5b",
   796 => x"51537279",
   797 => x"2e80c738",
   798 => x"80c10b81",
   799 => x"16811656",
   800 => x"56578275",
   801 => x"25df38ff",
   802 => x"a9177081",
   803 => x"ff065559",
   804 => x"73822683",
   805 => x"38875581",
   806 => x"537680d2",
   807 => x"2e983877",
   808 => x"5275519f",
   809 => x"c62d8053",
   810 => x"72880825",
   811 => x"89388715",
   812 => x"80f5cc0c",
   813 => x"81537288",
   814 => x"0c02a405",
   815 => x"0d047280",
   816 => x"f5d00b85",
   817 => x"802d8275",
   818 => x"25ff9a38",
   819 => x"99870494",
   820 => x"0802940c",
   821 => x"f93d0d80",
   822 => x"0b9408fc",
   823 => x"050c9408",
   824 => x"88050880",
   825 => x"25ab3894",
   826 => x"08880508",
   827 => x"30940888",
   828 => x"050c800b",
   829 => x"9408f405",
   830 => x"0c9408fc",
   831 => x"05088838",
   832 => x"810b9408",
   833 => x"f4050c94",
   834 => x"08f40508",
   835 => x"9408fc05",
   836 => x"0c94088c",
   837 => x"05088025",
   838 => x"ab389408",
   839 => x"8c050830",
   840 => x"94088c05",
   841 => x"0c800b94",
   842 => x"08f0050c",
   843 => x"9408fc05",
   844 => x"08883881",
   845 => x"0b9408f0",
   846 => x"050c9408",
   847 => x"f0050894",
   848 => x"08fc050c",
   849 => x"80539408",
   850 => x"8c050852",
   851 => x"94088805",
   852 => x"085181a7",
   853 => x"3f880870",
   854 => x"9408f805",
   855 => x"0c549408",
   856 => x"fc050880",
   857 => x"2e8c3894",
   858 => x"08f80508",
   859 => x"309408f8",
   860 => x"050c9408",
   861 => x"f8050870",
   862 => x"880c5489",
   863 => x"3d0d940c",
   864 => x"04940802",
   865 => x"940cfb3d",
   866 => x"0d800b94",
   867 => x"08fc050c",
   868 => x"94088805",
   869 => x"08802593",
   870 => x"38940888",
   871 => x"05083094",
   872 => x"0888050c",
   873 => x"810b9408",
   874 => x"fc050c94",
   875 => x"088c0508",
   876 => x"80258c38",
   877 => x"94088c05",
   878 => x"08309408",
   879 => x"8c050c81",
   880 => x"5394088c",
   881 => x"05085294",
   882 => x"08880508",
   883 => x"51ad3f88",
   884 => x"08709408",
   885 => x"f8050c54",
   886 => x"9408fc05",
   887 => x"08802e8c",
   888 => x"389408f8",
   889 => x"05083094",
   890 => x"08f8050c",
   891 => x"9408f805",
   892 => x"0870880c",
   893 => x"54873d0d",
   894 => x"940c0494",
   895 => x"0802940c",
   896 => x"fd3d0d81",
   897 => x"0b9408fc",
   898 => x"050c800b",
   899 => x"9408f805",
   900 => x"0c94088c",
   901 => x"05089408",
   902 => x"88050827",
   903 => x"ac389408",
   904 => x"fc050880",
   905 => x"2ea33880",
   906 => x"0b94088c",
   907 => x"05082499",
   908 => x"3894088c",
   909 => x"05081094",
   910 => x"088c050c",
   911 => x"9408fc05",
   912 => x"08109408",
   913 => x"fc050cc9",
   914 => x"399408fc",
   915 => x"0508802e",
   916 => x"80c93894",
   917 => x"088c0508",
   918 => x"94088805",
   919 => x"0826a138",
   920 => x"94088805",
   921 => x"0894088c",
   922 => x"05083194",
   923 => x"0888050c",
   924 => x"9408f805",
   925 => x"089408fc",
   926 => x"05080794",
   927 => x"08f8050c",
   928 => x"9408fc05",
   929 => x"08812a94",
   930 => x"08fc050c",
   931 => x"94088c05",
   932 => x"08812a94",
   933 => x"088c050c",
   934 => x"ffaf3994",
   935 => x"08900508",
   936 => x"802e8f38",
   937 => x"94088805",
   938 => x"08709408",
   939 => x"f4050c51",
   940 => x"8d399408",
   941 => x"f8050870",
   942 => x"9408f405",
   943 => x"0c519408",
   944 => x"f4050888",
   945 => x"0c853d0d",
   946 => x"940c0494",
   947 => x"0802940c",
   948 => x"ff3d0d80",
   949 => x"0b9408fc",
   950 => x"050c9408",
   951 => x"88050881",
   952 => x"06ff1170",
   953 => x"09709408",
   954 => x"8c050806",
   955 => x"9408fc05",
   956 => x"08119408",
   957 => x"fc050c94",
   958 => x"08880508",
   959 => x"812a9408",
   960 => x"88050c94",
   961 => x"088c0508",
   962 => x"1094088c",
   963 => x"050c5151",
   964 => x"51519408",
   965 => x"88050880",
   966 => x"2e8438ff",
   967 => x"bd399408",
   968 => x"fc050870",
   969 => x"880c5183",
   970 => x"3d0d940c",
   971 => x"04fc3d0d",
   972 => x"7670797b",
   973 => x"55555555",
   974 => x"8f72278c",
   975 => x"38727507",
   976 => x"83065170",
   977 => x"802ea738",
   978 => x"ff125271",
   979 => x"ff2e9838",
   980 => x"72708105",
   981 => x"54337470",
   982 => x"81055634",
   983 => x"ff125271",
   984 => x"ff2e0981",
   985 => x"06ea3874",
   986 => x"880c863d",
   987 => x"0d047451",
   988 => x"72708405",
   989 => x"54087170",
   990 => x"8405530c",
   991 => x"72708405",
   992 => x"54087170",
   993 => x"8405530c",
   994 => x"72708405",
   995 => x"54087170",
   996 => x"8405530c",
   997 => x"72708405",
   998 => x"54087170",
   999 => x"8405530c",
  1000 => x"f0125271",
  1001 => x"8f26c938",
  1002 => x"83722795",
  1003 => x"38727084",
  1004 => x"05540871",
  1005 => x"70840553",
  1006 => x"0cfc1252",
  1007 => x"718326ed",
  1008 => x"387054ff",
  1009 => x"8339fb3d",
  1010 => x"0d777970",
  1011 => x"72078306",
  1012 => x"53545270",
  1013 => x"93387173",
  1014 => x"73085456",
  1015 => x"54717308",
  1016 => x"2e80c438",
  1017 => x"73755452",
  1018 => x"71337081",
  1019 => x"ff065254",
  1020 => x"70802e9d",
  1021 => x"38723355",
  1022 => x"70752e09",
  1023 => x"81069538",
  1024 => x"81128114",
  1025 => x"71337081",
  1026 => x"ff065456",
  1027 => x"545270e5",
  1028 => x"38723355",
  1029 => x"7381ff06",
  1030 => x"7581ff06",
  1031 => x"71713188",
  1032 => x"0c525287",
  1033 => x"3d0d0471",
  1034 => x"0970f7fb",
  1035 => x"fdff1406",
  1036 => x"70f88482",
  1037 => x"81800651",
  1038 => x"51517097",
  1039 => x"38841484",
  1040 => x"16710854",
  1041 => x"56547175",
  1042 => x"082edc38",
  1043 => x"73755452",
  1044 => x"ff963980",
  1045 => x"0b880c87",
  1046 => x"3d0d0400",
  1047 => x"00ffffff",
  1048 => x"ff00ffff",
  1049 => x"ffff00ff",
  1050 => x"ffffff00",
  1051 => x"30313233",
  1052 => x"34353637",
  1053 => x"38394142",
  1054 => x"43444546",
  1055 => x"00000000",
  1056 => x"44485259",
  1057 => x"53544f4e",
  1058 => x"45205052",
  1059 => x"4f475241",
  1060 => x"4d2c2053",
  1061 => x"4f4d4520",
  1062 => x"53545249",
  1063 => x"4e470000",
  1064 => x"44485259",
  1065 => x"53544f4e",
  1066 => x"45205052",
  1067 => x"4f475241",
  1068 => x"4d2c2031",
  1069 => x"27535420",
  1070 => x"53545249",
  1071 => x"4e470000",
  1072 => x"44687279",
  1073 => x"73746f6e",
  1074 => x"65204265",
  1075 => x"6e63686d",
  1076 => x"61726b2c",
  1077 => x"20566572",
  1078 => x"73696f6e",
  1079 => x"20322e31",
  1080 => x"20284c61",
  1081 => x"6e677561",
  1082 => x"67653a20",
  1083 => x"43290a00",
  1084 => x"50726f67",
  1085 => x"72616d20",
  1086 => x"636f6d70",
  1087 => x"696c6564",
  1088 => x"20776974",
  1089 => x"68202772",
  1090 => x"65676973",
  1091 => x"74657227",
  1092 => x"20617474",
  1093 => x"72696275",
  1094 => x"74650a00",
  1095 => x"45786563",
  1096 => x"7574696f",
  1097 => x"6e207374",
  1098 => x"61727473",
  1099 => x"2c202564",
  1100 => x"2072756e",
  1101 => x"73207468",
  1102 => x"726f7567",
  1103 => x"68204468",
  1104 => x"72797374",
  1105 => x"6f6e650a",
  1106 => x"00000000",
  1107 => x"44485259",
  1108 => x"53544f4e",
  1109 => x"45205052",
  1110 => x"4f475241",
  1111 => x"4d2c2032",
  1112 => x"274e4420",
  1113 => x"53545249",
  1114 => x"4e470000",
  1115 => x"55736572",
  1116 => x"2074696d",
  1117 => x"653a2025",
  1118 => x"640a0000",
  1119 => x"4d696372",
  1120 => x"6f736563",
  1121 => x"6f6e6473",
  1122 => x"20666f72",
  1123 => x"206f6e65",
  1124 => x"2072756e",
  1125 => x"20746872",
  1126 => x"6f756768",
  1127 => x"20446872",
  1128 => x"7973746f",
  1129 => x"6e653a20",
  1130 => x"00000000",
  1131 => x"2564200a",
  1132 => x"00000000",
  1133 => x"44687279",
  1134 => x"73746f6e",
  1135 => x"65732070",
  1136 => x"65722053",
  1137 => x"65636f6e",
  1138 => x"643a2020",
  1139 => x"20202020",
  1140 => x"20202020",
  1141 => x"20202020",
  1142 => x"20202020",
  1143 => x"20202020",
  1144 => x"00000000",
  1145 => x"56415820",
  1146 => x"4d495053",
  1147 => x"20726174",
  1148 => x"696e6720",
  1149 => x"2a203130",
  1150 => x"3030203d",
  1151 => x"20256420",
  1152 => x"0a000000",
  1153 => x"50726f67",
  1154 => x"72616d20",
  1155 => x"636f6d70",
  1156 => x"696c6564",
  1157 => x"20776974",
  1158 => x"686f7574",
  1159 => x"20277265",
  1160 => x"67697374",
  1161 => x"65722720",
  1162 => x"61747472",
  1163 => x"69627574",
  1164 => x"650a0000",
  1165 => x"4d656173",
  1166 => x"75726564",
  1167 => x"2074696d",
  1168 => x"6520746f",
  1169 => x"6f20736d",
  1170 => x"616c6c20",
  1171 => x"746f206f",
  1172 => x"62746169",
  1173 => x"6e206d65",
  1174 => x"616e696e",
  1175 => x"6766756c",
  1176 => x"20726573",
  1177 => x"756c7473",
  1178 => x"0a000000",
  1179 => x"506c6561",
  1180 => x"73652069",
  1181 => x"6e637265",
  1182 => x"61736520",
  1183 => x"6e756d62",
  1184 => x"6572206f",
  1185 => x"66207275",
  1186 => x"6e730a00",
  1187 => x"44485259",
  1188 => x"53544f4e",
  1189 => x"45205052",
  1190 => x"4f475241",
  1191 => x"4d2c2033",
  1192 => x"27524420",
  1193 => x"53545249",
  1194 => x"4e470000",
  1195 => x"000061a8",
  1196 => x"00000000",
	others => x"00000000"
);

begin

process (clk)
begin
	if (clk'event and clk = '1') then
		if (from_zpu.memAWriteEnable = '1') and (from_zpu.memBWriteEnable = '1') and (from_zpu.memAAddr=from_zpu.memBAddr) and (from_zpu.memAWrite/=from_zpu.memBWrite) then
			report "write collision" severity failure;
		end if;
	
		if (from_zpu.memAWriteEnable = '1') then
			ram(to_integer(unsigned(from_zpu.memAAddr(maxAddrBitBRAM downto 2)))) := from_zpu.memAWrite;
			to_zpu.memARead <= from_zpu.memAWrite;
		else
			to_zpu.memARead <= ram(to_integer(unsigned(from_zpu.memAAddr(maxAddrBitBRAM downto 2))));
		end if;
	end if;
end process;

process (clk)
begin
	if (clk'event and clk = '1') then
		if (from_zpu.memBWriteEnable = '1') then
			ram(to_integer(unsigned(from_zpu.memBAddr(maxAddrBitBRAM downto 2)))) := from_zpu.memBWrite;
			to_zpu.memBRead <= from_zpu.memBWrite;
		else
			to_zpu.memBRead <= ram(to_integer(unsigned(from_zpu.memBAddr(maxAddrBitBRAM downto 2))));
		end if;
	end if;
end process;


end arch;

