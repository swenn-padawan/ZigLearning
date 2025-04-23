fn ft_strlen(string: []const u8) u64 {
    var index: u64 = 0;
    while (index < string.len and string[index] != 0)
        index += 1;
    
    return (index); 
}

const std = @import("std");

pub fn main() !void {
    const str = "womp womp";
    std.debug.print("size of {s} = {}", .{str, ft_strlen(str)});
}
