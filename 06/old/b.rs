//use std::env;
use std::fs;

fn main() {
  let contents = fs::read_to_string("./input")
      .expect("Error");
  let mut timers: Vec<u8> =
    contents.trim().split(',').map(|v| v.parse().unwrap()).collect();
  
  for d in 0..256 {
    println!("day {}: {}", d, timers.len());
    //println!("{:?}", &timers);
    let births: usize = timers.iter().filter(|&n| *n == 0).count();
    for t in &mut timers {
      if *t > 0 {
        *t = *t-1;
      } else {
        *t = 6;
      }
    }
    for _ in 0..births {
      timers.push(8);
    }
  }

  println!("final day: {}", timers.len());
}

