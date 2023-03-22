namespace helloQsharp {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation SayHello() : Unit {
        Message("Hello quantum world!");
        // prepareBellStatePsiPlus();
        // prepareBellStatePsiMinus();
        // prepareBellStatePhiPlus();
        // prepareBellStatePhiMinus();
        
        rotateWithControlledPhase();
        useCCNot();
    }

    operation prepareBellStatePsiPlus() : Unit {
        Message("entered prepare bell state psi plus");
        use qs = Qubit[2];

        H(qs[0]);
        CX(qs[0], qs[1]);

        DumpMachine();



        let bit1 = M(qs[0]);
        let bit2 = M(qs[1]);

        Message($"Hello, measured bits {bit1} {bit2}");

        Reset(qs[0]);
        Reset(qs[1]);
    }

    operation prepareBellStatePsiMinus() : Unit {
        Message("entered prepare psi minus");
        use qs = Qubit[2];

        H(qs[0]);
        CX(qs[0], qs[1]);
        Z(qs[0]);

        DumpMachine();


        
        let bit1 = M(qs[0]);
        let bit2 = M(qs[1]);
        Message($"Hello, measured bits {bit1} {bit2}");

        ResetAll(qs);

    }

    operation prepareBellStatePhiPlus() : Unit {
        Message("entered prepare phi plus");
        use qs = Qubit[2];

        H(qs[0]);
        X(qs[1]);
        CX(qs[0], qs[1]);

        DumpMachine();

        let bit1 = M(qs[0]);
        let bit2 = M(qs[1]);
        Message($"Hello, measured bits {bit1} {bit2}");

        ResetAll(qs);

    }

    operation prepareBellStatePhiMinus() : Unit {
        Message("entered prepare phi minus");
        use qs = Qubit[2];
        H(qs[0]);
        CX(qs[0], qs[1]);
        X(qs[1]);
        Z(qs[1]);

        DumpMachine();

        let bit1 = M(qs[0]);
        let bit2 = M(qs[1]);
        Message($"Hello, measured bits {bit1} {bit2}");

        ResetAll(qs);

    }

    operation rotateWithControlledPhase() : Unit {
        // equal superposition all states, rotate 5 and 7 by 36 degrees
        use qs = Qubit[3];

        H(qs[0]);
        H(qs[1]);
        H(qs[2]);

        let theta = PI() / 4.0;
        Controlled R1([qs[0]], (theta, qs[2]));

        DumpMachine();
        ResetAll(qs);
    }

    operation useCCNot() : Unit {
        Message("entered ccnot!");
        use qs = Qubit[3];

        X(qs[0]);
        X(qs[2]);
        CCNOT(qs[0], qs[2], qs[1]);

        DumpMachine();

        ResetAll(qs);
    }
}
