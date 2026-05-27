# GravityBall

A gravity-controlled ball game for the [Playdate](https://play.date/) handheld console.

Tilt your Playdate to guide the ball toward the target while avoiding traps. Each level adds more obstacles and increases sensitivity, making the game progressively harder.

![GravityBall gameplay](screenshots/Screenshot%201.5.106.png)

## How to Play

- **A button** — Start the game / advance to the next level
- **Tilt** — Move the ball using the accelerometer
- **B button + Crank** — Adjust sensitivity

Reach the target (flag icon) to score a point and advance. Hit a trap (x icon) and it's game over.

## Building

Requires the [Playdate SDK](https://play.date/dev/).

```sh
make build
```

This compiles the source and opens the game in the Playdate Simulator.

## License

BSD Zero Clause License — see [License.md](License.md) for details.
