use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::PathBuf;

use hashbrown::HashMap;
use armake2::PBO;
use regex::Regex;

static MISSION: &str = "zeusFreestyle.Stratis.pbo";

fn main() {
    let re = Regex::new(r"(?m)(.+?)\s?(?:/.+?)?$").unwrap();

    let mut out = File::create(&MISSION).unwrap();
    let mut pbo = PBO::from_directory(PathBuf::from("zeusFreestyle.Stratis"), false, &[], &[]).unwrap();
    pbo.header_extensions = HashMap::new();
    pbo.write(&mut out).unwrap();

    std::fs::create_dir("missions").unwrap();

    let file = File::open("maps.txt").unwrap();
    for line in BufReader::new(file).lines() {
        let line = line.unwrap();
        let m = re.captures(&line).unwrap();
        let line = m.get(1).unwrap().as_str();
        if line == "" { continue; }
        let mission = MISSION.replace("Stratis", line);
        println!("{}", mission);
        std::fs::copy(MISSION, format!("missions\\{}", mission)).unwrap();
    }
}
