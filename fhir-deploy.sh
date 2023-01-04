export OS_CMD="oc apply -f - "

$OS_CMD << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fhir
spec:
  replicas: 1
  selector:
    matchLabels:
      dataquack: fhir
  strategy:
    type: Recreate
  template:
    metadata:
        labels:
          dataquack: fhir
    spec:
      containers:
        - env:
            - name: FHIR_USER_PASSWORD
              value: <PASSWORD>
            - name: FHIR_ADMIN_PASSWORD
              value: <PASSWORD>
          image: ibmcom/ibm-fhir-server:4.5.4 
          name: fhir
          ports:
            - containerPort: 9443
          resources: {}
      restartPolicy: Always
status: {}
EOF