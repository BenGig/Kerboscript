function enter_string {
  
  set c to terminal:input:getchar().
  set input to c.
  until c = terminal:input:ENTER {
    set c to terminal:input:getchar().
	set input to input + c.
  }
  return input.
}