package com.rustyrazorblade.easycasslab.commands

import com.beust.jcommander.Parameters
import com.github.ajalt.mordant.TermColors
import com.rustyrazorblade.easycasslab.Context
import com.rustyrazorblade.easycasslab.configuration.ServerType

@Parameters(commandDescription = "Restart cassandra", commandNames = ["restart"])
class Restart(val context: Context) : ICommand {
    override fun execute() {
        // TODO wait for cassandra to become available
        println("Restarting cassandra service on all nodes.")
        with(TermColors()) {
            context.tfstate.withHosts(ServerType.Cassandra) {
                println(green("Restarting $it"))
                context.executeRemotely(it, "/usr/local/bin/restart-cassandra-and-wait")
            }
        }
    }
}