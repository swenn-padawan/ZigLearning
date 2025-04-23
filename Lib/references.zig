//zig.guide 0.13

const std = @import("std");
const expect = @import("std").testing.expect;

//if statement----------------------------------------------------------------//
test "if statement" {
    const a = true;
    var x: u16 = 0;
    x += if (a) 1 else 2;
    try expect(x == 1);
}

//while loop------------------------------------------------------------------//
test "while loop" {
    var i: u8 = 2;
    while (i < 100){
        i *= 2;
    }
    try expect(i == 128);
}

test "while with continue expression" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) { //le (i += 1) est ce quon appelle une post expression (comme l'increment des for en C)
        sum += i;
    }
    try expect(sum == 55);
}

//for loop--------------------------------------------------------------------//
test "for" {
    //character literals are equivalent to integer literals
    const string = [_]u8{ 'a', 'b', 'c' };

    // for (collection [, index_range]) |element [, index]|{corps de la boucle}
    // A savoir que ZIG se deplace tout seul (pas besoin de str[i++] ou str++)
    // jusqu'a la fin de la string (out of bound protegé)
    for (string, 0..) |character, index| {
        std.debug.print("Index {d}, char {c}\n", .{index, character});
    }

    for (string) |character| {
        _ = character;
    }

    for (string, 0..) |_, index| {
        _ = index;
    }

    for (string) |_| {}
}


//Fonctions-------------------------------------------------------------------//
fn addFive(x: u32) u32 {
    return (x + 5);
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
    const x = fibonacci(10);
    try expect(x == 55);
}

//Defer-----------------------------------------------------------------------//
//S'execute a la sortie du bloc
test "defer"{
    var x: i16 = 5;
    {
        defer x += 2;
        try expect(x == 5);
    }
    try expect(x == 7);
}

//Errors----------------------------------------------------------------------//
 const FileOpenErrors = error{
     AccessDenied,
     OutofMemory,
     FileNotFound
 };

const AllocationError = error{OutofMemory};

test "coerce error from a subset to a superset" {
    const err: FileOpenErrors = AllocationError.OutofMemory;
    try expect(err == FileOpenErrors.OutofMemory);
}
//Error can be combined with the ! operator to form an error union type
test "error union" {
    const maybe_error: AllocationError!u16 = 10;
    const no_error = maybe_error catch 0;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        try expect(err == error.Oops);
        return;
    };
}

fn FailFn() error{Oops}!i32 {
    try failingFunction();
    return (12);
}

test "try" {
    const v = FailFn() catch |err| {
        try expect(err == error.Oops);
        return;
    };
    try expect(v == 12);
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void{
    errdefer problems += 1;
    try failingFunction();
}

test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99);
        return ;
    };
}

fn CreateFile() !void {
    return error.AccessDenied;
}

test "infered error set" {
    const x: error{AccessDenied}!void = CreateFile();
    //Zig does not let us ignore error unions via _ = x;
    //we must unwrap it with "try", "catch", or "if" by any means
    _ = x catch {};
}

    //Error can be merged
const A = error{ NotDir, PathNotFound};
const B = error{ OutofMemory, PathNotFound};
const C = A || B;

//Switch----------------------------------------------------------------------//


pub fn main() !void {
    const nb: u32 = 8;
    std.debug.print("{}", .{addFive(nb)});

}
