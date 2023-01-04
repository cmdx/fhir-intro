export OS_CMD="oc apply -f - "
export OS_DATABASE=fhir
export OS_DBPORT=9443
export OS_NODEPORT=30100

$OS_CMD << EOF 
kind: Service
apiVersion: v1
metadata:
  name: ${OS_DATABASE}
  labels:
    dataquack: ${OS_DATABASE}
spec:
  ports:
    - name: "${OS_DBPORT}"
      protocol: TCP
      port: ${OS_DBPORT}
      targetPort: ${OS_DBPORT}
      nodePort: ${OS_NODEPORT}
  selector:
    dataquack: ${OS_DATABASE}
  type: LoadBalancer
EOF