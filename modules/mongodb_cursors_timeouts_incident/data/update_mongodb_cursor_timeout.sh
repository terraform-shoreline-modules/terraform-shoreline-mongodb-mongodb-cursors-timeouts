

#!/bin/bash



# Set the new cursor timeout limit

NEW_TIMEOUT_LIMIT=${NEW_TIMEOUT_LIMIT}



# Update the MongoDB configuration file with the new timeout limit

sudo sed -i "s/cursorTimeoutMillis:.*/cursorTimeoutMillis: $NEW_TIMEOUT_LIMIT/g" /etc/mongod.conf



# Restart the MongoDB service to apply the changes

sudo systemctl restart mongod