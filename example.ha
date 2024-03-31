use fmt;
use ll;

export fn main() void = {
	const l = ll::createlist();
	defer ll::destroylist(&l);
	ll::addtostart(&l, "0");
	ll::addtostart(&l, "-1");
	ll::add(&l, "1", 2);
	fmt::println(ll::tostring(&l))!;
};
