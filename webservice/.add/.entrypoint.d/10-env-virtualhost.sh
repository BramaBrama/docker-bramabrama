################################################################################
# environment initialization

if [ -z "${VIRTUAL_HOST:+x}" ] ; then
    $( (cat | tee /etc/profile.d/10-local-env-virtualhost.sh) << EOF
export VIRTUAL_HOST=$HOSTNAME
EOF
)
fi
