// RUN: %swift -parse %s -verify

// -------------------------------------------------------------------------
// Restrictions on where @required can appear
// -------------------------------------------------------------------------
@required class AC { } // expected-error{{'required' attribute can only be applied to an initializer}}

class C {
  @required init withString(s: String) { } // expected-note{{'required' initializer with type '(withString: String)' not overridden}}

  @required var s: String // expected-error{{'required' attribute can only be applied to an initializer}}

  @required func f() { } // expected-error{{'required' attribute can only be applied to an initializer}}
}

struct S {
  @required init() { } // expected-error{{'required' initializer in non-class type 'S'}}
}

enum E {
  @required init() { } // expected-error{{'required' initializer in non-class type 'E'}}
}

extension C {
  @required init withString2(s: String) -> Self { self.init(withString:s) } // expected-error{{'required' initializer must be declared directly in class 'C' (not in an extension)}}
}

// -------------------------------------------------------------------------
// Subclass requirements for @required
// -------------------------------------------------------------------------
class C2 : C { // expected-error{{class 'C2' does not implement its superclass's required members}}
}

class C3 : C {
  @required init withString(s: String) { }
}

class C4 : C3 {
  // implicitly @required
  init withString(s: String) { } // expected-note{{'required' initializer with type '(withString: String)' not overridden}}
}

class C5 : C4 { // expected-error{{class 'C5' does not implement its superclass's required members}}
}



