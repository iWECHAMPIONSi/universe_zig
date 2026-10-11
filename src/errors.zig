pub const StdErr = error{
    InvalidParameter,
    MemoryAllocationFailed,
    InvalidStateReached,
    InvalidFnCall,
    RuntimeFnCalledAtComptime,
    DuplicateHash,
};
