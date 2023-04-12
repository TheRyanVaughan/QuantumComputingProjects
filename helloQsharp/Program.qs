namespace helloQsharp {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;


    @EntryPoint()
    operation SayHello() : Unit {
        // prepareBellStatePsiPlus();
        // prepareBellStatePsiMinus();
        // prepareBellStatePhiPlus();
        // prepareBellStatePhiMinus();
        
        // rotateWithControlledPhase();
        // useCCNot();
        
        TeleportAndVerify();
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


    
    // Helper operation to prepare Bell state on two qubits
    operation PrepareBellState (q1 : Qubit, q2 : Qubit) : Unit is Adj {
        H(q1);
        CNOT(q1, q2);
    }

    // Helper operation to perform measurement in Bell basis
    operation MeasureBellBasis (q1 : Qubit, q2 : Qubit) : (Result, Result) {
        // convert the qubits from Bell basis to computational basis
        Adjoint PrepareBellState(q1, q2);
        // measure both qubits and return results
        return (MResetZ(q1), MResetZ(q2));
    }

    operation TeleportAndVerify () : Unit {
        // allocate the qubits: the pair that will be entangled and shared between Alice and Bob and Alice's data qubit
        use (aliceEPR, bobEPR, data) = (Qubit(), Qubit(), Qubit());
        // prepare the data qubit in some superposition state
        Ry(1.0, data);
        Message("The state to be teleported:");
        DumpRegister((), [data]);
        
        // set up teleportation: prepare the entangled pair of qubits
        PrepareBellState(aliceEPR, bobEPR);
        
        // Alice's part of the protocol
        let message = MeasureBellBasis(data, aliceEPR);
        
        // Alice sends measurement results to Bob (no direct representation in Q# code)
        
        // let's observe the state of the system at this point
        Message("");
        Message($"Measurement results: {message}");
        Message("");
        Message("The state of Bob's qubit after Alice's measurement");
        DumpRegister((), [bobEPR]);
        
        // Bob applies fixup to his qubit based on the information he received from Alice
        let (fix1, fix2) = message;
        if (fix2 == One) {
            X(bobEPR);
        }
        if (fix1 == One) {
            Z(bobEPR);
        }
        
        // regardless of measurement results, Bob's qubit is now in the required state!
        Message("");
        Message("Teleportation result (the state of Bob's qubit)");
        DumpRegister((), [bobEPR]);

        // to verify this, we can apply adjoint of the prep operation to Bob's qubit - the result will be |0❭
        Adjoint Ry(1.0, bobEPR);
        
        // (if teleportation failed, the program will throw exception at this point)
    }
}

