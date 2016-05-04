clear all; close all;

% Grid length (between 1 and 41)
l = 41;

% Probabilities
p_same_dir = [0.8 0.2]; 
p_change_dir = [0.6 0.4];

% start and end point
start = [1 ; 1];
target = [41 ; 41];

% (horizontal, vertical) coordinates of critical organs

C = [    18    30
     1    13
     7     4
     8    15
    17    23
    18    29
     9    37
     2    28
    18    23
     6     9
    33    40
    13    29
    36    37
     4     2
     7    37
     5    18
    40    22
    29    13
    29    35
     1    31
    41    31
    12    33
     5    19
    38    13
    12     6
     1    28
     9    11
    21     3
    24     7
    25    29
     5    17
    29    17
     3    22
    28    22
    39    25
    38     6
     6    34
    17     7
    39    15
    31    30
    37    26
    31    15
    12    37
    18    40
    28    26
     5    39
    19    24
    17    10
    38    24
     1    26
    14    22
    37    15
    38    26
     1    39
    29    41
     8     6
    39    29
     3    31
    31    38
    30     6
     1     2
     2    11
    36    23
    23    35
     6    12
    25    40
    24     1
    33    10
    34    16
    36    31
    23     6
     3     5
     2     5
    10    30
    23     1
     3    40
    24     9
    11    31
     9    24
    40    35
    10    21
    26    34
     7     1
     3    20
    25    24
    14    41
    24    16
    23    31
    28    11
     3    16
    26     9
    31     3
    11    33
     8    27
    22    38
    11     3
    31    32
    38    39
     1    10
    26    39];


figure
plot(target(1),target(2),'ro');
axis([1 l 1 l]);
hold on
plot(start(1),start(2),'r.');
plot(C(:,1),C(:,2),'bx');
hold off