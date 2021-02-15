#!/bin/bash
# Add a warning
cat << EOF > "$PREFIX/.messages.txt"
Thanks for testing out the OpenMM development builds!
-----------------------------------------------------
This is a nightly build of the latest snapshot
available on the `master` branch. Code has not been
released as part of a stable version yet, so it is
NOT production ready!
EOF
