use strings;

export type node = struct {
	data: str,
	next: nullable *node,
};

// Converts nullable *node into *node
// Most errors happen here
fn unwrapnode(n: nullable *node) *node = {
	let n = match (n) {
	case null =>
		abort();
	case let n: *node =>
		yield n;
	};
	return n;
};

fn hasnext(n: *node) bool = {
	if (n.next == null) { return false; };
	return true;
};

export type list = struct {
	head: nullable *node,
	elements: int,
};

// Create a new empty list
export fn createlist() list = {
	return list { head = null, elements = 0 };
};

// Free all the data inside the list
export fn destroylist(l: *list) void = {
	for (let n = unwrapnode(l.head); hasnext(n)) {
		const prev = n;
		n = unwrapnode(n.next);
		free(prev);
	};
};

// Get *node at specified index
fn getnode(l: *list, i: int) *node = {
	if (i < 0 || i > l.elements-1) abort();
	const n = unwrapnode(l.head);
	for (let num: int = 0; num < i; num += 1) {
		n = unwrapnode(n.next);
	};
	return n;
};

// Get element data at specified index
export fn get(l: *list, i: int) str = {
	if (i < 0 || i >= l.elements) abort();
	let n = unwrapnode(l.head);
	for (let num: int = 0; num < i; num += 1) {
		n = unwrapnode(n.next);
	};
	return n.data;
};

// Add an element to the beginning of the list
export fn addtostart(l: *list, s: str) void = {
	if (l.head == null) {
		const n: *node = alloc(node { data = s, next = null });
		l.head = n;
	} else {
		const n: *node = alloc(node { data = s, next = unwrapnode(l.head) });
		l.head = n;
	};
	l.elements += 1;
};

// Add an element at the specified index to the list
export fn add(l: *list, s: str, i: int) void = {
	if (i < 0 || i > l.elements) abort();
	if (i == 0) {
		addtostart(l, s);
		return;	
	};
	const n = getnode(l, i-1);
	const new: *node = alloc(node { data = s, next = n.next });
	n.next = new;
	l.elements += 1;
};

// Remove an element at the specified index from the list
export fn pop(l: *list, i: int) void = {
	if (i < 0) abort();
	if (i == 0) {
		const head = unwrapnode(l.head);
		l.head = head.next;
		free(head);
		l.elements -= 1;
		return;
	};
	const prev = getnode(l, i-1);
	if (prev.next == null) return;
	const r = unwrapnode(prev.next);
	prev.next = r.next;
	free(r);
	l.elements -= 1;
};

// Get a string representation of the list
export fn tostring(l: *list) str = {
	if (l.elements == 0) return "[]";
	if (l.elements == 1) return strings::join("", "[", unwrapnode(l.head).data, "]");
	let ret = strings::join("", "[", unwrapnode(l.head).data);
	let n = unwrapnode(unwrapnode(l.head).next);
	for (let n = n; hasnext(n); n = unwrapnode(n.next)) {
		ret = strings::join(", ", ret, n.data);
	};
	if (l.elements > 2) n = unwrapnode(n.next);
	ret = strings::join(", ", ret, n.data);
	ret = strings::join("", ret, "]");
	return ret;
};
