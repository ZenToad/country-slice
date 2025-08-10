package main

import "core:math/linalg"
import "core:math"
import "vendor:glfw"
import "vendor:gl"

Vec3 :: linalg.Vec3
Mat4 :: linalg.Mat4

// Simple free-flight camera structure
Camera :: struct {
    position: Vec3,
    yaw: f32,
    pitch: f32,
    speed: f32,
}

init_camera :: proc() -> Camera {
    return Camera{position = {0, 0, 3}, yaw = -90.0, pitch = 0.0, speed = 5.0}
}

// Build a view matrix from the camera's orientation
get_view_matrix :: proc(cam: Camera) -> Mat4 {
    yaw_r   := math.radians(cam.yaw)
    pitch_r := math.radians(cam.pitch)

    front := linalg.normalize(Vec3{
        math.cos(pitch_r) * math.cos(yaw_r),
        math.sin(pitch_r),
        math.cos(pitch_r) * math.sin(yaw_r),
    })

    return linalg.look_at(cam.position, cam.position + front, Vec3{0, 1, 0})
}

main :: proc() {
    glfw.init()
    defer glfw.terminate()

    window := glfw.create_window(1280, 720, "Odin Camera", nil, nil)
    glfw.make_context_current(window)
    gl.load(glfw.get_proc_address)
    gl.enable(gl.DEPTH_TEST)

    cam := init_camera()

    for !glfw.window_should_close(window) {
        glfw.poll_events()
        // TODO: handle keyboard/mouse to move cam
        view := get_view_matrix(cam)
        proj := linalg.perspective_rh(math.radians(60.0), 1280.0/720.0, 0.1, 100.0)
        // Pass view and proj matrices to shaders here

        gl.clear_color(0.1, 0.1, 0.1, 1.0)
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

        glfw.swap_buffers(window)
    }
}
