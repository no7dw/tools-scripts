db.currentOp().inprog.forEach(
  function(op) {
    if(op.secs_running > 5) printjson(op);
  }
)
killLongRunningOps = function(maxSecsRunning) {
    currOp = db.currentOp();
    for (oper in currOp.inprog) {
        op = currOp.inprog[oper-0];
        if (op.secs_running > maxSecsRunning && op.op == "query" && !op.ns.startsWith("local")) {
            print("Killing opId: " + op.opid
                    + " running for over secs: "
                    + op.secs_running);
            db.killOp(op.opid);
        }
    }
};
