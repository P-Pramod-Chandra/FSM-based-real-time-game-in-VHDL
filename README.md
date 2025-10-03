# FSM-based-real-time-game-in-VHDL
I have designed a two player pingpong game which is to played on a XEN10 FPGA and used its 8-LED array as the display. 
## Rules of the Game
There is a ball(a lit-up LED) which goes around and bounces off the edges of the 
### Scoring
## Implementation
### Finite State Diagram
```mermaid
stateDiagram-v2
    [*] --> IDLE : reset
    IDLE --> TORIGHT: push3=0
    IDLE --> TOLEFT : push0=1
    TORIGHT --> TOLEFT : push3=0
    TOLEFT --> TORIGHT : push0=1
    TOLEFT --> SCORE : score3>=40?
    TORIGHT --> SCORE : score0>=40?
    
