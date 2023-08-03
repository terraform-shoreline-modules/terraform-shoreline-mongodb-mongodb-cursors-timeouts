
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB cursors timeouts incident
---

The MongoDB cursors timeouts incident refers to an issue where too many cursors are timing out in a MongoDB instance. This can cause disruptions in the normal functioning of the database and lead to delays in processing queries. This incident type requires immediate attention from the software engineer to resolve the issue and prevent any further damage to the system.

### Parameters
```shell
# Environment Variables

export DATABASE_NAME="PLACEHOLDER"

export CLIENT_ADDRESS="PLACEHOLDER"

export OPID="PLACEHOLDER"

export NEW_TIMEOUT_LIMIT="PLACEHOLDER"

```

## Debug

### Check if MongoDB is running
```shell
systemctl status mongod
```

### Check MongoDB logs for any errors related to cursors
```shell
tail -f /var/log/mongodb/mongod.log | grep 'cursor'
```

### Check the current number of open cursors
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.serverStatus().cursors)"
```

### Check the number of cursors being used by a specific client
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.currentOp({'client_s' : '${CLIENT_ADDRESS}'}))"
```

### Check the number of cursors being used by all clients
```shell
mongo ${DATABASE_NAME} --eval "printjson(db.currentOp({'active': true, 'op': 'query', 'ns': /${DATABASE_NAME}./, '$where': 'this.cursorInfo != null'}))"
```

### Kill a specific cursor
```shell
mongo ${DATABASE_NAME} --eval "db.killOp(${OPID})"
```

## Repair

### Increase the cursor timeout limit if necessary to prevent timeouts from occurring in the future.
```shell


#!/bin/bash



# Set the new cursor timeout limit

NEW_TIMEOUT_LIMIT=${NEW_TIMEOUT_LIMIT}



# Update the MongoDB configuration file with the new timeout limit

sudo sed -i "s/cursorTimeoutMillis:.*/cursorTimeoutMillis: $NEW_TIMEOUT_LIMIT/g" /etc/mongod.conf



# Restart the MongoDB service to apply the changes

sudo systemctl restart mongod


```