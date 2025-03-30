--!strict
export type component = {
	onAwake: ((self: any) -> ())?,
	onUpdate: ((self: any, dt: number) -> ())?
}

return nil