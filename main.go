package main

import (
	"sync"

	"github.com/lorioux/kitabus/commands"
	"github.com/lorioux/kitabus/globals"
	"github.com/lorioux/kitabus/mappings"
)

func init() {
	globals.Control = &sync.Map{}

	globals.GetContext = globals.InitContext
	globals.CamService, _ = globals.InitService()
	globals.MapOfAllTFResourcesWithData = new(sync.Map)
	globals.MapOfAllTFResourcesByFilePath = new(sync.Map)
	globals.ListOfAllTFResourcesWithData = []*globals.Asset{}
	globals.GlossaryOfNamesById = map[string]string{}

	globals.Reversor = mappings.ResourceReversorInstance()
	globals.GlobalCMDRunner = commands.LocalCmdRunner
	globals.TFResourceMapInstancesByType = new(sync.Map)
	globals.TFResourceBodyByType = new(sync.Map)
	globals.TFModuleBodyByService = new(sync.Map)
}

func Execute() {
	// commands.CmdExecute()
	commands.Execute()
}

func main() {
	Execute()
}
