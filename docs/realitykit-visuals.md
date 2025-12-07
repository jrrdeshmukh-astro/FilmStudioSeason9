# RealityKit Stunning Visuals Guide

This document explains how FilmStudioPilot uses RealityKit's MaterialBuilder and visual components to create stunning 3D storyboard visuals.

## MaterialBuilder API

### PhysicallyBasedMaterial

We use `PhysicallyBasedMaterial` for realistic, physically-accurate rendering:

```swift
var material = PhysicallyBasedMaterial()

// Base color
material.baseColor = .init(
    texture: nil,
    color: UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1.0)
)

// Metallic properties
material.metallic = PhysicallyBasedMaterial.Metallic(
    texture: nil,
    scalar: 0.9
)

// Roughness
material.roughness = PhysicallyBasedMaterial.Roughness(
    texture: nil,
    scalar: 0.1
)

// Clearcoat for glossy surfaces
material.clearcoat = PhysicallyBasedMaterial.Clearcoat(
    amount: 0.5,
    roughness: 0.05
)
```

### Material Types

**1. Metallic Materials**
- High metallic value (0.9)
- Low roughness (0.1)
- Clearcoat for mirror-like surfaces
- Use for: Metal props, chrome, steel

**2. Fabric Materials**
- Zero metallic
- High roughness (0.8)
- Sheen component for fabric shine
- Use for: Clothing, curtains, soft props

**3. Glass Materials**
- Low opacity (0.3)
- Zero metallic and roughness
- High transmission (0.95)
- Use for: Windows, glass props, transparent objects

**4. Skin Materials**
- Subsurface scattering for realistic skin
- Medium roughness (0.6)
- Warm color tint
- Use for: Characters, faces

**5. Wood Materials**
- Zero metallic
- Medium-high roughness (0.7)
- Natural color tones
- Use for: Tables, furniture, set pieces

**6. Emissive Materials**
- Emissive color for glowing effects
- Use for: Lights, screens, magical effects

## Visual Components

### ShadowComponent

Adds realistic shadows to entities:

```swift
entity.components.set(ShadowComponent(shadow: .init(opacity: 0.5)))
```

**Benefits:**
- Depth perception
- Ground contact realism
- Scene cohesion

### CollisionComponent

Enables interaction and physics:

```swift
entity.components.set(CollisionComponent(shapes: [.generateBox(size: entity.scale)]))
```

**Use Cases:**
- User interaction
- Physics simulation
- Ray casting

### PhysicsBodyComponent

Adds physics behavior:

```swift
entity.components.set(PhysicsBodyComponent(
    massProperties: .default,
    material: .default,
    mode: .static // or .dynamic
))
```

**Modes:**
- `.static`: Fixed in place (walls, floors)
- `.dynamic`: Movable (props, characters)

### OcclusionComponent

Adds realistic depth occlusion:

```swift
entity.components.set(OcclusionComponent())
```

**Benefits:**
- Proper depth sorting
- Realistic object hiding
- Performance optimization

## Advanced Lighting

### Three-Point Lighting Setup

**1. Key Light (Main Directional)**
- Primary illumination
- Strong intensity (1.0)
- Directional shadow casting

**2. Fill Light (Ambient)**
- Softens shadows
- Lower intensity (0.3-0.4)
- Prevents harsh contrast

**3. Rim Light (Back Light)**
- Edge definition
- Creates separation from background
- Cool color (blue-tinted)

### Shadow Configuration

```swift
lightEntity.light.shadow = .init(
    maximumDistance: 10.0,
    depthBias: 2.0
)
```

**Parameters:**
- `maximumDistance`: How far shadows cast
- `depthBias`: Prevents shadow acne

## Atmospheric Effects

### Fog

Configure fog in `EnvironmentConfig`:

```swift
EnvironmentConfig(
    fogEnabled: true,
    fogColor: ColorRGB(r: 0.8, g: 0.8, b: 0.9),
    fogDistance: 10.0
)
```

**Use Cases:**
- Depth perception
- Mood setting
- Scene transitions

## Emotional Moment Enhancements

### Emissive Glow

For emotional moments, add subtle emissive glow:

```swift
if isEmotional {
    material.emissiveColor = .init(
        texture: nil,
        color: UIColor(
            red: CGFloat(color.r * 0.3),
            green: CGFloat(color.g * 0.3),
            blue: CGFloat(color.b * 0.3),
            alpha: 1.0
        )
    )
}
```

### Warm Lighting

Emotional moments use warmer, softer lighting:

```swift
DirectionalLight(
    direction: [0.3, -0.8, -0.5],
    color: ColorRGB(r: 1.0, g: 0.95, b: 0.9), // Warm
    intensity: 0.8
)
```

## Mesh Generation

### Character Meshes

Use organic shapes for characters:

```swift
MeshResource.generateSphere(radius: 0.3)
```

### Prop Meshes

Generate appropriate shapes based on prop type:

```swift
// Table
MeshResource.generateBox(width: 1.5, height: 0.1, depth: 0.8)

// Chair
MeshResource.generateBox(width: 0.5, height: 1.0, depth: 0.5)

// Lamp
MeshResource.generateCylinder(radius: 0.05, height: 1.0)
```

### Set Meshes

Larger scale for environment:

```swift
// Door
MeshResource.generateBox(width: 0.8, height: 2.0, depth: 0.1)

// Wall
MeshResource.generateBox(width: 5.0, height: 3.0, depth: 0.2)

// Floor
MeshResource.generateBox(width: 5.0, height: 0.1, depth: 5.0)
```

## Best Practices

### 1. Material Selection

Match material type to object:
- Metal objects → Metallic material
- Organic objects → Skin/Fabric material
- Transparent objects → Glass material

### 2. Lighting Balance

Maintain 3-point lighting:
- Key: 1.0 intensity
- Fill: 0.3-0.4 intensity
- Rim: 0.2-0.3 intensity

### 3. Shadow Quality

Enable shadows for:
- Ground contact
- Depth perception
- Scene realism

### 4. Performance

Optimize for performance:
- Use static physics for fixed objects
- Limit shadow casting lights
- Use occlusion culling

### 5. Emotional Enhancement

For emotional moments:
- Warmer color temperature
- Softer shadows
- Subtle emissive glow
- Closer camera angles

## Example: Complete Scene Setup

```swift
// 1. Create entity with advanced material
let characterMesh = MeshResource.generateSphere(radius: 0.3)
let characterMaterial = createAdvancedMaterial(
    color: ColorRGB(r: 0.9, g: 0.8, b: 0.7),
    materialType: .skin,
    isEmotional: true
)
let character = ModelEntity(mesh: characterMesh, materials: [characterMaterial])

// 2. Add visual components
character.components.set(ShadowComponent(shadow: .init(opacity: 0.5)))
character.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.3)]))
character.components.set(OcclusionComponent())

// 3. Configure lighting
let keyLight = DirectionalLight()
keyLight.light.intensity = 1.0
keyLight.light.shadow = .init(maximumDistance: 10.0, depthBias: 2.0)
keyLight.position = simd_float3(2, 3, 2)

// 4. Add to scene
rootEntity.addChild(character)
rootEntity.addChild(keyLight)
```

## Resources

- **RealityKit Materials**: https://developer.apple.com/documentation/realitykit/material
- **PhysicallyBasedMaterial**: https://developer.apple.com/documentation/realitykit/physicallybasedmaterial
- **Visual Components**: https://developer.apple.com/documentation/realitykit/components
- **Lighting**: https://developer.apple.com/documentation/realitykit/lighting

---

This guide ensures all 3D storyboards in FilmStudioPilot use stunning, realistic visuals powered by RealityKit's advanced rendering capabilities.

