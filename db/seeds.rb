TracklistsTrack.delete_all
Tracklist.delete_all
Track.delete_all

core_tracks = [
  {
    name: "Neon Drift",
    artist: "Aria Vale",
    genre: "Progressive House",
    key: "A minor",
    bpm: 124.0
  },
  {
    name: "Signal Bloom",
    artist: "Myles Roe",
    genre: "Deep House",
    key: "F minor",
    bpm: 122.0
  },
  {
    name: "Helios Path",
    artist: "Lina Grey",
    genre: "Tech House",
    key: "D minor",
    bpm: 126.0
  },
  {
    name: "Soft Satellite",
    artist: "Keon Ellis",
    genre: "Electronica",
    key: "C minor",
    bpm: 118.0
  }
]

additional_tracks = [
  {
    name: "Midnight Circuit",
    artist: "Nova Line",
    genre: "Progressive House",
    key: "G minor",
    bpm: 123.0
  },
  {
    name: "Glass Tide",
    artist: "Jori Ames",
    genre: "Deep House",
    key: "E minor",
    bpm: 121.0
  },
  {
    name: "Silent Harbor",
    artist: "Oren Wells",
    genre: "Melodic Techno",
    key: "A minor",
    bpm: 124.0
  },
  {
    name: "Bloomline",
    artist: "Marin Lune",
    genre: "Tech House",
    key: "F minor",
    bpm: 126.0
  },
  {
    name: "Echoes on Cables",
    artist: "Tessa Prime",
    genre: "Electronica",
    key: "B minor",
    bpm: 117.0
  },
  {
    name: "Terra Glide",
    artist: "Luca Ember",
    genre: "Progressive House",
    key: "C minor",
    bpm: 124.0
  },
  {
    name: "Low Sun",
    artist: "Rae Lumen",
    genre: "Deep House",
    key: "G minor",
    bpm: 120.0
  },
  {
    name: "Violet Banks",
    artist: "Sev Mira",
    genre: "Melodic Techno",
    key: "D minor",
    bpm: 125.0
  },
  {
    name: "Static Orchard",
    artist: "Ivo Hale",
    genre: "Tech House",
    key: "A minor",
    bpm: 127.0
  },
  {
    name: "Night Ferry",
    artist: "Pia North",
    genre: "Electronica",
    key: "E minor",
    bpm: 116.0
  },
  {
    name: "Arctic Signal",
    artist: "Quinn Shore",
    genre: "Progressive House",
    key: "F minor",
    bpm: 123.0
  },
  {
    name: "Alley Lights",
    artist: "Juno Reid",
    genre: "Deep House",
    key: "C minor",
    bpm: 121.0
  },
  {
    name: "Moon Relay",
    artist: "Cass Lyra",
    genre: "Melodic Techno",
    key: "B minor",
    bpm: 126.0
  },
  {
    name: "Halation",
    artist: "Remy Sol",
    genre: "Tech House",
    key: "D minor",
    bpm: 128.0
  },
  {
    name: "Lattice Air",
    artist: "Nico Vale",
    genre: "Electronica",
    key: "G minor",
    bpm: 118.0
  },
  {
    name: "Slow Bloom",
    artist: "Ada Knox",
    genre: "Progressive House",
    key: "A minor",
    bpm: 122.0
  },
  {
    name: "Copperline",
    artist: "Theo Marr",
    genre: "Deep House",
    key: "F minor",
    bpm: 120.0
  },
  {
    name: "Trace Signal",
    artist: "Mara Drift",
    genre: "Melodic Techno",
    key: "C minor",
    bpm: 125.0
  },
  {
    name: "Azure Block",
    artist: "Lenn Hart",
    genre: "Tech House",
    key: "E minor",
    bpm: 127.0
  },
  {
    name: "Folding Light",
    artist: "Nira Rose",
    genre: "Electronica",
    key: "D minor",
    bpm: 116.0
  },
  {
    name: "Arc Glide",
    artist: "Soren Beck",
    genre: "Progressive House",
    key: "B minor",
    bpm: 123.0
  },
  {
    name: "Silverline",
    artist: "Tali Reed",
    genre: "Deep House",
    key: "A minor",
    bpm: 121.0
  },
  {
    name: "Quartz Field",
    artist: "Elio Moss",
    genre: "Melodic Techno",
    key: "F minor",
    bpm: 124.0
  },
  {
    name: "Dust in Bloom",
    artist: "Nia Rowe",
    genre: "Tech House",
    key: "C minor",
    bpm: 126.0
  },
  {
    name: "Crimson Delay",
    artist: "Arlen Fox",
    genre: "Electronica",
    key: "E minor",
    bpm: 117.0
  },
  {
    name: "Pulse Orchard",
    artist: "Evan Sage",
    genre: "Progressive House",
    key: "G minor",
    bpm: 124.0
  },
  {
    name: "Skyline Static",
    artist: "Vera Lux",
    genre: "Deep House",
    key: "D minor",
    bpm: 122.0
  },
  {
    name: "Long Arc",
    artist: "Kian Holt",
    genre: "Melodic Techno",
    key: "B minor",
    bpm: 126.0
  },
  {
    name: "Harborline",
    artist: "Iris Cove",
    genre: "Tech House",
    key: "F minor",
    bpm: 127.0
  },
  {
    name: "Quiet Engine",
    artist: "Theo Marek",
    genre: "Electronica",
    key: "A minor",
    bpm: 118.0
  }
]

tracks = (core_tracks + additional_tracks).map { |attrs| Track.create!(attrs) }
core = tracks.first(core_tracks.size)

tracklist_seed = [
  {
    name: "Coastal Circuit",
    date: Date.new(2025, 6, 14),
    artwork: "https://assets.memoir.example/tracklists/coastal-circuit.jpg",
    url: "https://memoir.example/tracklists/coastal-circuit"
  },
  {
    name: "Midnight Press",
    date: Date.new(2025, 7, 5),
    artwork: "https://assets.memoir.example/tracklists/midnight-press.jpg",
    url: "https://memoir.example/tracklists/midnight-press"
  },
  {
    name: "Summit Bloom",
    date: Date.new(2025, 7, 19),
    artwork: "https://assets.memoir.example/tracklists/summit-bloom.jpg",
    url: "https://memoir.example/tracklists/summit-bloom"
  },
  {
    name: "Night Garden",
    date: Date.new(2025, 8, 2),
    artwork: "https://assets.memoir.example/tracklists/night-garden.jpg",
    url: "https://memoir.example/tracklists/night-garden"
  },
  {
    name: "Copper Fields",
    date: Date.new(2025, 8, 16),
    artwork: "https://assets.memoir.example/tracklists/copper-fields.jpg",
    url: "https://memoir.example/tracklists/copper-fields"
  },
  {
    name: "Amber Relay",
    date: Date.new(2025, 9, 6),
    artwork: "https://assets.memoir.example/tracklists/amber-relay.jpg",
    url: "https://memoir.example/tracklists/amber-relay"
  },
  {
    name: "Signal Loft",
    date: Date.new(2025, 9, 20),
    artwork: "https://assets.memoir.example/tracklists/signal-loft.jpg",
    url: "https://memoir.example/tracklists/signal-loft"
  },
  {
    name: "Velvet Transit",
    date: Date.new(2025, 10, 4),
    artwork: "https://assets.memoir.example/tracklists/velvet-transit.jpg",
    url: "https://memoir.example/tracklists/velvet-transit"
  },
  {
    name: "Quiet Current",
    date: Date.new(2025, 10, 18),
    artwork: "https://assets.memoir.example/tracklists/quiet-current.jpg",
    url: "https://memoir.example/tracklists/quiet-current"
  },
  {
    name: "Sky Lanterns",
    date: Date.new(2025, 11, 1),
    artwork: "https://assets.memoir.example/tracklists/sky-lanterns.jpg",
    url: "https://memoir.example/tracklists/sky-lanterns"
  },
  {
    name: "Mirror Tones",
    date: Date.new(2025, 11, 15),
    artwork: "https://assets.memoir.example/tracklists/mirror-tones.jpg",
    url: "https://memoir.example/tracklists/mirror-tones"
  },
  {
    name: "Orchard Fade",
    date: Date.new(2025, 12, 6),
    artwork: "https://assets.memoir.example/tracklists/orchard-fade.jpg",
    url: "https://memoir.example/tracklists/orchard-fade"
  }
]

core_count = core.size
tracklist_seed.each_with_index do |attrs, index|
  tracklist = Tracklist.create!(attrs)
  pick_count = 8 + (index % 5)
  offset = (index * 6) % (tracks.size - core_count)
  slice = tracks[core_count, tracks.size - core_count].slice(offset, pick_count - core_count)
  selections = core + slice
  selections.each_with_index do |track, position|
    TracklistsTrack.create!(
      tracklist_id: tracklist.id,
      track_id: track.id,
      track_number: position + 1
    )
  end
end
